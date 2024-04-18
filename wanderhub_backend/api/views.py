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
from .models import VisitedLandmarks, Landmark, Itineraries, ItineraryItems
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
    visited_landmarks = VisitedLandmarks.objects.filter(user=user).select_related('landmark')
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

    # VisitedLandmarks.objects.create(user=user, landmark=landmark, visit_time=now())
    VisitedLandmarks.objects.create(user=user, landmark=landmark, visit_time=now(), rating = 3)
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
    
    #user = request.user
    #interests = request.data.get('interests')
    #city_name = request.data.get('city_name')
    #country_name = request.data.get('country_name')
    #start_date = request.data.get('start_date') #Must be YYYY-MM-DD
    #end_date = request.data.get('end_date') #Must be YYYY-MM-DD

    #prompt_with_input = "You are a travel assistant. You will help me write a customized travel itinerary with only specific landmarks. Here is some information about me to help you" + interests + " I am travelling to " +  city_name + ", " + country_name + " with dates from " + start_date + " to" + end_date + " Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{itinerary_name: Fun Itinerary Name,itinerary: [{date_time: Date Time in django parsable format,landmark: landmark name,latitude: latitude in float,longitude: longitude in float}]}"

    visited_landmarks = VisitedLandmarks.objects.filter(user=request.user)
    landmarks = [visit.landmark.name for visit in visited_landmarks]
    landmarks_string = ", ".join(landmarks)

    prompt_with_input = "You are a travel assistant. You will help me write a customized travel itinerary with only specific landmarks. Here is some information about me to help you. I have already been to these landmarks: " + landmarks_string + ". Please recommend me new landmarks that are similar to these in terms of geographic location and context (historical, touristic, etc). If I have not provided you any landmarks, then you can be more flexible and provide more generic landmarks as you see fit. Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{itinerary_name: Fun Itinerary Name, landmarks: [list of landmarks in string format], duration: recommended_duration_of_travel}"

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

    #new_it = Itineraries.objects.create(user=user, it_name=response_data["itinerary_name"], city_name=city_name, start_date=start_date)
    #for item in response_data["itinerary"]:
       #ItineraryItems.objects.create(it_id = new_it, landmark_name=item["landmark"], date_time=item["date_time"], latitude=item["latitude"], longitude=item["longitude"])

    return Response(generated_text)

@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_itineraries(request):
    user = request.user
    user_itineraries = Itineraries.objects.filter(user=user).values('it_name')
    itineraries = [{"city_name": i.city_name, "it_name": i.it_name, "start_date": i.start_date.strftime("%Y-%m-%d")} 
                      for i in user_itineraries]
    return Response(itineraries)

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
def update_landmark_rating(request):
    username = request.user
    landmark_name = request.data.get("landmark_name")
    try:
        item = VisitedLandmarks.objects.filter(user=username).get(name=landmark_name)
    except ItineraryItems.DoesNotExist:
        raise NotFound("Landmark not found")
    
    item.rating = request.POST.get("new_rating")
    item.save()
    
    return Response(f"Landmark Rating updated")

def update_user_weights(username):
    #all_landmarks = VisitedLandmarks.objects.filter(user=username)
    user_weights = UserTags.objects.get(username=username)
    tags = [
        "Art",
        "Architecture",
        "Beach",
        "Entertainment",
        "Food",
        "Hiking",
        "History",
        "Mountains",
        "Museum",
        "Music",
        "Recreation",
        "Scenic Views",
        "Sports"
        ]
    avgs = []
    for tag in tags:
        visited_landmarks_with_tag = VisitedLandmarks.objects.filter(user=user, landmark__tags__name=tag)
        running_sum = 0
        runnning_count = 0
        for landmark in visited_landmarks_with_tag:
            running_sum += landmark.rating
            running_count += 1
        if running_count == 0:
            running_sum = 1
            running_count = 0
        avgs.append(running_sum/running_count)
    user_weights.art = avgs[0]
    user_weights.architecture = avgs[1]
    user_weights.beach = avgs[2]
    user_weights.entertainment = avgs[3]
    user_weights.food = avgs[4]
    user_weights.hiking = avgs[5]
    user_weights.history = avgs[6]
    user_weights.mountains = avgs[7]
    user_weights.museum = avgs[8]
    user_weights.music = avgs[9]
    user_weights.recreation = avgs[10]
    user_weights.scenicViews = avgs[11]
    user_weights.sports = avgs[12]
        
        

