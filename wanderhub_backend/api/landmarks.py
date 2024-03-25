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

import os
from django.conf import settings
from django.core.files.storage import FileSystemStorage
import time
from google.cloud import vision

@api_view(["POST"])
def post_landmarks(request):
    # loading multipart/form-data
    username = request.POST.get("username")
    timestamp = request.POST.get("timestamp")

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
    return Response({"success": serializer.is_valid(), "url_for_image": imageUrl})

@api_view(["GET"])
# @authentication_classes([SessionAuthentication, TokenAuthentication])
# @permission_classes([IsAuthenticated])
def get_landmark(request):
    # user = request.user
    # user = "cctran"
    
    # Retrieve the latest image from the database (replace this with your own logic)
    # latest_object = LandmarkIdentification.objects.filter(user=user).order_by('timestamp').first()
    latest_object = LandmarkIdentification.objects.order_by('-timestamp').first()

    # Get the URL of the image from the database
    image_url = latest_object.url_for_image  # Replace 'image_url' with the actual field name in your model

    # Call the function to perform landmark detection
    result = landmarkDetection(image_url)

    # Process the result as needed
    return Response({'landmarks_info':result})

def landmarkDetection(file_path):
    """Detects landmarks in the local file."""
    # Initialize the Google Cloud client library
    client = vision.ImageAnnotatorClient()

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
    
    # Load the image into memory
    with open(filepath, 'rb') as image_file:
        content = image_file.read()

    image = vision.Image(content=content)

    # Perform landmark detection
    response = client.landmark_detection(image=image)
    # json_response = vision.AnnotateImageResponse.to_json(response)

    # print(json_response)
    landmarks = response.landmark_annotations
    
    # Create a list to store landmark descriptions
    landmark_descriptions = []

    # Append each landmark description to the list
    for landmark in landmarks:
        landmark_descriptions.append(landmark.description)

    return landmark_descriptions