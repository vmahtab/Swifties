from rest_framework.decorators import api_view
from rest_framework.response import Response
import requests

from .serializers import UserSerializer
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth.models import User

from django.shortcuts import get_object_or_404

from rest_framework.decorators import authentication_classes, permission_classes
from rest_framework.authentication import SessionAuthentication, TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from django.contrib.auth import get_user_model
from .models import VisitedCities, Landmark, Itineraries, ItineraryItems
from rest_framework.exceptions import NotFound
from django.utils.timezone import now

from dotenv import load_dotenv
import os

import json

from openai import OpenAI

load_dotenv()
api_key = os.getenv("API_KEY")
client = OpenAI(api_key=api_key)

@api_view(["POST"])
def login(request):
    user = get_object_or_404(User, username=request.data['username'])
    if not user.check_password(request.data['password']):
        return Response({"detail": "Not found."}, status=status.HTTP_400_BAD_REQUEST)
    
    token, created = Token.objects.get_or_create(user=user)

    serializer = UserSerializer(instance=user)
    return Response({"token": token.key, "user": serializer.data})


@api_view(["POST"])
def signup(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        user = User.objects.get(username=request.data['username'])        
        user.set_password(request.data['password'])
        user.save()
        token = Token.objects.create(user=user)
        return Response({"token": token.key, "user": serializer.data})

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_landmarks(request):
    user = request.user
    visited_landmarks = VisitedCities.objects.filter(user=user).select_related('landmark')
    landmarks_info = [{"city_name": vl.landmark.city_name, "country_name": vl.landmark.country_name, 
                       "landmark_name": vl.landmark.name, "image_url": vl.landmark.image_url, "visit_time": vl.visit_time.strftime("%Y-%m-%d %H:%M:%S")} 
                      for vl in visited_landmarks]
    return Response(landmarks_info)

@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_user_landmark(request):
    user = request.user
    landmark_name = request.data.get("landmark_name")
    try:
        landmark = Landmark.objects.get(name=landmark_name)
    except Landmark.DoesNotExist:
        raise NotFound("Landmark not found")

    VisitedCities.objects.create(user=user, landmark=landmark, visit_time=now())
    return Response(f"New visit added for {user.email} to {landmark.name}")

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def test_token(request):
    return Response("passed for {}".format(request.user.email))


@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def make_custom_itinerary(request):
    
    user = request.user
    city_name = request.data.get('city_name')
    country_name = request.data.get('country_name')
    start_date = request.data.get('start_date') #Must be YYYY-MM-DD
    end_date = request.data.get('end_date') #Must be YYYY-MM-DD

    prompt_with_input = "You are a travel assistant. You will help me write a customized travel itinerary with only specific landmarks. Here is some information about me to help you. Give me landmarks with tags of art, architecture, beach, entertainment, food, hiking, history, mountains, museum, music, recreation, scenic views, sports with ratios of "+art+" "+architecture+" "+beach+" "+entertainment+" "+food+" "+hiking+" "+history+" "+mountains+" "+museum+" "+music+" "+recreation+" "+scenic_views+" "+sports+"respectively. I am travelling to " +  city_name + ", " + country_name + " with dates from " + start_date + " to" + end_date + " Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{itinerary_name: Fun Itinerary Name,itinerary: [{date_time: Date Time in django parsable format,landmark: landmark name,tags: tags as specified above,latitude: latitude in float,longitude: longitude in float}]}"

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

    new_it = Itineraries.objects.create(user=user, it_name=response_data["itinerary_name"], city_name=city_name, start_date=start_date)
    for item in response_data["itinerary"]:
       ItineraryItems.objects.create(it_id = new_it, landmark_name=item["landmark"], date_time=item["date_time"], latitude=item["latitude"], longitude=item["longitude"])

    return Response(generated_text)

@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_to_itinerary(request):
    
    user = request.user
    itinerary_id = request.get.data('itinerary_id')
    date = request.get.data('day')
    itinerary = Itineraries.objects.filter(id = itinerary_id)
    city_name = itinerary.city_name
    start_date = itinerary.start_date

    prompt_with_input = "You are a travel assistant. You will help me add one itinerary item of a specific landmark. Here is some information about me to help you. Give me one landmark with tags of art, architecture, beach, entertainment, food, hiking, history, mountains, museum, music, recreation, scenic views, sports with ratios of "+art+" "+architecture+" "+beach+" "+entertainment+" "+food+" "+hiking+" "+history+" "+mountains+" "+museum+" "+music+" "+recreation+" "+scenic_views+" "+sports+"respectively. I am travelling to " +  city_name + " with a start date of " + start_date + "Return the date for day "+date+" of the trip. Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{date_time: Date Time in django parsable format,landmark: landmark name,tags: tags as specified above,latitude: latitude in float,longitude: longitude in float}"

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

    ItineraryItems.objects.create(it_id = itinerary_id, landmark_name=response_data["landmark"], date_time=response_data["date_time"], latitude=response_data["latitude"], longitude=response_data["longitude"])

    return Response(generated_text)

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_nearby_landmarks(request):
    
    user = request.user
    latitude = request.data.get('latitude')
    longitude = request.data.get('longitude')
    distance = request.data.get('distance')

    prompt_with_input = "You are a travel assistant. You will help me find nearby specific landmarks. Here is some information about me to help you. Give me landmarks with tags of art, architecture, beach, entertainment, food, hiking, history, mountains, museum, music, recreation, scenic views, sports with ratios of "+art+" "+architecture+" "+beach+" "+entertainment+" "+food+" "+hiking+" "+history+" "+mountains+" "+museum+" "+music+" "+recreation+" "+scenic_views+" "+sports+"respectively. I am located at latitude " +  latitude + ", and longitude " + longitude + "Only find me landmarks within "+distance+". Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{{landmark: landmark name,tags: tags as specified above,latitude: latitude in float,longitude: longitude in float, distance:distance from where I am in kilometers}}"

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

    #distance returned in kilometers
    return Response(generated_text)

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_itineraries(request):
    user = request.user
    user_itineraries = Itineraries.objects.filter(user=user).values('id')
    itineraries = [{"id": i.id, "city_name": i.city_name, "it_name": i.it_name, "start_date": i.start_date.strftime("%Y-%m-%d")} 
                      for i in user_itineraries]
    return Response(itineraries)

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_itinerary_details(request):
    user = request.user
    itinerary_id = request.get.data('itinerary_id')
    itinerary_items = ItineraryItems.objects.filter(id=itinerary_id).values('id')
    items = [{"it_id": i.it_id, "landmark_name":i.landmark_name, "date_time": i.date_time.strftime('%a %H:%M  %Y/%m/%d'), "latitude":i.latitude, "longitude":i.longitude} 
                      for i in itinerary_items]
    return Response(items)

@api_view(["DELETE"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def remove_from_itinerary(request):
    item_id = request.data.get("id")
    try:
        item = ItineraryItems.objects.get(id=item_id)
    except ItineraryItems.DoesNotExist:
        raise NotFound("Itinerary Item not found")
    
    ItineraryItems.objects.get(id = item_id).delete()
    return Response(f"Itinerary Item deleted")

@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def intialize_user_preferences(request):

    user = request.user
    art = request.data.get('Art')
    architecture = request.data.get('Architecture')
    beach = request.data.get('Beach')
    entertainment = request.data.get('Entertainment')
    food = request.data.get('Food')
    hiking = request.data.get('Hiking')
    history = request.data.get('History')
    mountains = request.data.get('Mountains')
    museum = request.data.get('Museum')
    music = request.data.get('Music')
    recreation = request.data.get('Recreation')
    scenic_views = request.data.get('Scenic_views')
    sports = request.data.get('Sports')

    interests = [art, architecture, beach, entertainment, food, hiking, history, mountains, museum, music, recreation, scenic_views, sports]
    total = sum(interests)
    interests = [x/total for x in interests]
    remain = 0
    selected = 0

    for x in interests:
        if(x!=0):
            remain += max(x-0.3, 0)
            x = min(x, 0.3)
            selected+=1

    to_update = 13 - selected
    for x in interests:
        if(x==0):
            x = remain/to_update

    #update here


    
