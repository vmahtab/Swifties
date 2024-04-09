from rest_framework.decorators import api_view
from rest_framework.response import Response

from .serializers import ImageDataSerializer
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User

from django.shortcuts import get_object_or_404

from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth import get_user_model
from .models import VisitedCities, Landmark, LandmarkIdentification
from rest_framework.exceptions import NotFound
from django.utils.timezone import now


from django.conf import settings
from django.core.files.storage import FileSystemStorage
import time
from google.cloud import vision
from math import radians, sin, cos, acos

import json

from dotenv import load_dotenv
import os

from openai import OpenAI


load_dotenv()
api_key = os.getenv("API_KEY")
client_ChatGPT = OpenAI(api_key=api_key)

@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def post_landmarks(request):
    '''Save landmark picture to database. Expects multiform data and returns status and url for get request.'''
    # loading multipart/form-data
    username = request.POST.get("username")
    timestamp = request.POST.get("timestamp")
    # timestamp = time.time()

    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = username+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageUrl = fs.url(filename)
    else:
        imageUrl = None

    lat = request.POST.get("lat")
    lon = request.POST.get("lon")
    place = request.POST.get("place")
    facing = request.POST.get("facing")
    speed = request.POST.get("speed")
    
    serializer = ImageDataSerializer(data={
    'username': username,
    'timestamp': timestamp,
    'url_for_image': imageUrl,
    'lat': lat,
    'lon': lon,
    'place': place,
    'facing': facing,
    'speed': speed,
    })

    # Validate the data
    if serializer.is_valid():
        # Save the validated data to the database
        serializer.save()
    else:
        # Handle validation errors
        errors = serializer.errors
        return Response({"error": errors})
    return Response({"success": serializer.is_valid(), "url_for_image": imageUrl})

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_landmark(request):
    '''Perform landmark identification on latest picture taken. Expects no data and returns landmark name of most recent picture taken by user'''
    user = request.user
    # user = "cctran"
    
    # Retrieve the latest image from the database (replace this with your own logic)
    # latest_object = LandmarkIdentification.objects.filter(username=user).order_by('timestamp').first()
    latest_object = LandmarkIdentification.objects.order_by('-timestamp').first() # --> testing without user

    # Get the URL of the image from the database
    image_url = latest_object.url_for_image  # Replace 'image_url' with the actual field name in your model

    # Call the function to perform landmark detection
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "eecs-441-417520-db5559970077.json"
    result = landmarkDetection(image_url)

    # Process the result as needed
    return Response({'landmarks_info':result})

def landmarkDetection(file_path):
    '''Detects landmarks passed in the parameter using google vision api and returns most accurate landmark.'''
    # Open the file
    # with open('apiKey.txt', 'r') as file:
        # Read the contents of the file
        # file_contents = file.read()

    # Initialize the Google Cloud client library
    client_Google = vision.ImageAnnotatorClient(
            client_options={"api_key": "AIzaSyA5vyof07KCRP1ctCnXqBeOm5xuqENix40", "quota_project_id": "eecs-441-417520"}
    )

    # gives the path of demo.py 
    path = os.path.realpath(__file__) 
    
    # gives the directory where demo.py  
    # exists 
    dir = os.path.dirname(path) 
    
    # replaces folder name of Sibling_1 to  
    # Sibling_2 in directory 
    dir = dir.replace('api', 'media') 
    
    # changes the current directory to  
    # Sibling_2 folder 
    os.chdir(dir) 

    filepath = file_path.strip("/")
    # print(file_path)
    absolute_path = "/home/ubuntu/Swifties/wanderhub_backend/media" + file_path
    # Load the image into memory
    with open(absolute_path, 'rb') as image_file:
        content = image_file.read()

    image = vision.Image(content=content)

    # Perform landmark detection
    response = client_Google.landmark_detection(image=image)
    # json_response = vision.AnnotateImageResponse.to_json(response)

    # print(json_response)
    landmarks = response.landmark_annotations
    
    # Create a list to store landmark descriptions
    latest_object = LandmarkIdentification.objects.order_by('-timestamp').first()
    latitude = (latest_object.lat)
    longitude = (latest_object.lon)
    current_coord = (latitude, longitude)
    closest_landmark = "Landmark could not be identified"
    min_distance = float('inf')

    # Append each landmark description to the list
    for landmark in landmarks:
        lat_lng = landmark.locations[0].lat_lng
        latitude = (lat_lng.latitude)
        longitude = (lat_lng.longitude)
        coord = (latitude, longitude)

        dist = distance(current_coord, coord)
        if dist < min_distance:
            min_distance = dist
            closest_landmark = landmark.description

        #landmark_descriptions.append(landmark.description)
            
    # image_file.close()
    # os.remove(filepath)

    return closest_landmark

def distance(coord1, coord2):
    '''Calculates the distance between two coordinates.'''
    x1, y1 = coord1
    x2, y2 = coord2
    # Euclidean Distance
    # return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)
 
    # Spherical law of cosines
    lat1 = radians(float(x1))
    lon1 = radians(float(y1))
    lat2 = radians(float(x2))
    lon2 = radians(float(y2))
    
    return 6371.01 * acos(sin(lat1)*sin(lat2) + cos(lat1)*cos(lat2)*cos(lon1 - lon2))

@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def post_landmark_info(request):
    '''Gives information about the landmark with optional interest. Expects landmark name and optional interest/focus and returns relevant info'''

    landmark_name = request.data.get("landmark_name")
    interest = request.data.get("interest")

    prompt_with_input = "You are a wikipedia. You will give me information about the " + landmark_name + " with this focus: " + interest + ". If I have not provided you any focus, then you can be more flexible and provide more generic information as you see fit. Provide a  RFC8259 compliant JSON response following this format without deviation: {'landmark_info': 'Information about the landmark in paragraph form, include who made the landmark, when it was made, and why it was made.'}"

    try:
        completion = client_ChatGPT.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": prompt_with_input,
                }
            ],
            model="gpt-3.5-turbo",
            response_format={"type": "json_object"}
        )
        generated_text = completion.choices[0].message.content
    except Exception as e:
        return Response({'error': str(e)}, status=500)

    response_data = json.loads(generated_text)

    return Response(response_data)
