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
from .models import VisitedLandmarks, Landmark, LandmarkIdentification
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
def post_landmark_id_and_info(request):
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

    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "eecs-441-417520-db5559970077.json"
    client_Google = vision.ImageAnnotatorClient(
            client_options={"api_key": "AIzaSyA5vyof07KCRP1ctCnXqBeOm5xuqENix40", "quota_project_id": "eecs-441-417520"}
    )
    path = os.path.realpath(__file__) 
    dir = os.path.dirname(path) 
    dir = dir.replace('api', 'media') 
    os.chdir(dir) 
    absolute_path = "/home/ubuntu/Swifties/wanderhub_backend/media" + imageUrl
    with open(absolute_path, 'rb') as image_file:
        content = image_file.read()
    image = vision.Image(content=content)
    response = client_Google.landmark_detection(image=image)
    landmarks = response.landmark_annotations
    current_coord = (lat, lon)
    closest_landmark = "Landmark could not be identified"
    min_distance = float('inf')
    for landmark in landmarks:
        lat_lng = landmark.locations[0].lat_lng
        latitude = (lat_lng.latitude)
        longitude = (lat_lng.longitude)
        coord = (latitude, longitude)

        dist = distance(current_coord, coord)
        if dist < min_distance:
            min_distance = dist
            closest_landmark = landmark.description
    result = closest_landmark

    try:
        landmark = Landmark.objects.get(name=result)
    except Landmark.DoesNotExist:
        #raise NotFound("Landmark not found")
        landmark = Landmark.objects.create(name = result, city_name = " ", country_name = " ", image_url = imageUrl)

        prompt_with_input = "Given these tags [Art, Architecture, Beach, Entertainment, Food, Hiking, History, Mountains, Museum, Music, Recreation, Scenic Views, Sports], what tag would you give the colloseum? Do not include any explanations, provide a  RFC8259 compliant JSON response following this format without deviation: {'tags': [list of tags]}"

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

        for tag in response_data["tags"]:
            landmark.tags.add(tag)

        # TODO: Get tags for new landmark?

    VisitedLandmarks.objects.create(user=user, landmark=landmark, visit_time=now(), rating = 3)
    # return Response(f"New visit added for {user.email} to {landmark.name}")

    return Response({'landmarks_info':result})
    '''
    if (result ==  "Landmark could not be identified"){
        return Response({"landmark_name": result, "landmark_info": result})
    }
    # interest = request.data.get("interest")
    interest = 'history'
    return Response({"landmark_info": result})
    prompt_with_input = "You are a wikipedia. You will give me information about the " + result + " with this focus: " + interest + ". If I have not provided you any focus, then you can be more flexible and provide more generic information as you see fit. Provide a  RFC8259 compliant JSON response following this format without deviation: {'landmark_info': 'Information about the landmark in paragraph form, include who made the landmark, when it was made, and why it was made.'}"
    return Response({"prompt": prompt_with_input, "landmark_info": result})
    try:
        completion = client.chat.completions.create(
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

    # response_data.update({"landmark_name": result})

    return Response(response_data)
    '''


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