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
from .models import VisitedLandmarks, Landmark, Itineraries, ItineraryItems, UserTags, Tag
from rest_framework.exceptions import NotFound
from django.utils.timezone import now

from dotenv import load_dotenv
import os

import json

import random

from openai import OpenAI

load_dotenv()
api_key = os.getenv("API_KEY")
client = OpenAI(api_key=api_key)


@api_view(["POST"])
def login(request):
    user = get_object_or_404(User, username=request.data["username"])
    if not user.check_password(request.data["password"]):
        return Response({"detail": "Not found."}, status=status.HTTP_400_BAD_REQUEST)

    token, created = Token.objects.get_or_create(user=user)

    serializer = UserSerializer(instance=user)
    return Response({"token": token.key, "user": serializer.data})


@api_view(["POST"])
def signup(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        user = User.objects.get(username=request.data["username"])
        user.set_password(request.data["password"])
        user.save()
        token = Token.objects.create(user=user)
        return Response({"token": token.key, "user": serializer.data})

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_landmarks(request):
    user = request.user
    visited_landmarks = (
        VisitedLandmarks.objects.filter(user=user)
        .select_related("landmark")
        .prefetch_related("landmark__tags")
    )

    landmarks_info = [
        {
            "id": vl.landmark.id,
            "landmark_name": vl.landmark.name,
            "city_name": vl.landmark.city_name,
            "country_name": vl.landmark.country_name,
            "description": vl.landmark.description,
            "tags": [tag.name for tag in vl.landmark.tags.all()],
            "visit_time": vl.visit_time.strftime("%Y-%m-%d %H:%M:%S"),
            "rating": vl.rating,
            "image_url": vl.image_url,
        }
        for vl in visited_landmarks
    ]

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
    VisitedLandmarks.objects.create(
        user=user, landmark=landmark, visit_time=now(), rating=3
    )
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
    city_name = request.data.get("city_name")
    country_name = request.data.get("country_name")
    start_date = request.data.get("start_date")  # Must be YYYY-MM-DD
    end_date = request.data.get("end_date")  # Must be YYYY-MM-DD

    try:
        tags = UserTags.objects.get(user=user)
    except UserTags.DoesNotExist:
        return Response(f"UserTags.DoesNotExist")
    art = str(tags.art)
    architecture = str(tags.architecture)
    beach = str(tags.beach)
    entertainment = str(tags.entertainment)
    food = str(tags.food)
    hiking = str(tags.hiking)
    history = str(tags.history)
    mountains = str(tags.mountains)
    museum = str(tags.museum)
    music = str(tags.music)
    recreation = str(tags.recreation)
    scenic_views = str(tags.scenicViews)
    sports = str(tags.sports)

    prompt_with_input = (
        "You are a travel assistant. You will help me write a customized travel itinerary with only specific landmarks. Here is some information about me to help you. Give me at least 10 landmarks with tags of Art, Architecture, Beach, Entertainment, Food, Hiking, History, Mountains, Museum, Music, Recreation, Scenic Views, Sports with ratios of "
        + art
        + " "
        + architecture
        + " "
        + beach
        + " "
        + entertainment
        + " "
        + food
        + " "
        + hiking
        + " "
        + history
        + " "
        + mountains
        + " "
        + museum
        + " "
        + music
        + " "
        + recreation
        + " "
        + scenic_views
        + " "
        + sports
        + "respectively. I am travelling to "
        + city_name
        + ", "
        + country_name
        + " with dates from "
        + start_date
        + " to"
        + end_date
        + " Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{Trip: {it_name: fun name for itinerary, city: city name, country: country name, startDate = start date as MM/DD/YYYY, endDate: end date as MM/DD/YYYY, Landmarks: [{name: landmark name,message: short description of landmark, tags: tags as specified above,latitude: latitude in float 10 decimal precision,longitude: longitude in float 10 decimal precision, day: int for day from start of the trip, rating: int of 3}]}}"
    )
    
    try:
        completion = client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": prompt_with_input,
                }
            ],
            model="gpt-3.5-turbo",
            response_format={"type": "json_object"},
        )
        generated_text = completion.choices[0].message.content
    except Exception as e:
        return Response({"error": str(e)}, status=500)

    # Removed during merge
    response_data = json.loads(generated_text)

    # return Response({"response" : response_data})

    trip = response_data["Trip"]

    new_it = Itineraries.objects.create(
        user=user,
        it_name=trip["it_name"],
        city_name=city_name,
        start_date=start_date,
    )

    response_data["itinerary_id"] = new_it.id

    for i in trip["Landmarks"]:
        landmark_info = {
            "name": i["name"],
            "city": trip["city"],
            "country": trip["country"],
            "description": i["message"],
            "tags": i["tags"],
        }
        try:
            landmark = Landmark.objects.get(name=landmark_info["name"])
        except Landmark.DoesNotExist:
            landmark = Landmark(
                name=landmark_info["name"],
                city_name=landmark_info["city"],
                country_name=landmark_info["country"],
                description=landmark_info["description"],
            )
            landmark.save()

            for tag in landmark_info["tags"]:
                try:
                    tag = Tag.objects.get(name=tag)
                    landmark.tags.add(tag)
                except Tag.DoesNotExist:
                    pass
            landmark.save()

        ItineraryItems.objects.create(
            it_id=new_it,
            landmark_name=landmark,
            trip_day=i["day"],
            latitude=i["latitude"],
            longitude=i["longitude"],
        )

    return Response(response_data)


@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def add_to_itinerary(request):

    user = request.user
    itinerary_id = request.data.get("itinerary_id")
    day = request.data.get("day")
    try:
        itinerary = Itineraries.objects.get(id=itinerary_id)
    except Itineraries.DoesNotExist:
        return Response("Itinerary does not exist", status=status.HTTP_404_NOT_FOUND)
    city_name = itinerary.city_name
    start_date = str(itinerary.start_date)

    try:
        tags = UserTags.objects.get(user=user)
    except UserTags.DoesNotExist:
        return Response(f"UserTags.DoesNotExist")
    art = str(tags.art)
    architecture = str(tags.architecture)
    beach = str(tags.beach)
    entertainment = str(tags.entertainment)
    food = str(tags.food)
    hiking = str(tags.hiking)
    history = str(tags.history)
    mountains = str(tags.mountains)
    museum = str(tags.museum)
    music = str(tags.music)
    recreation = str(tags.recreation)
    scenic_views = str(tags.scenicViews)
    sports = str(tags.sports)

    prompt_with_input = (
        "You are a travel assistant. You will help me add one itinerary item of a specific landmark. Here is some information about me to help you. Give me one landmark with tags of Art, Architecture, Beach, Entertainment, Food, Hiking, History, Mountains, Museum, Music, Recreation, Scenic Views, Sports with ratios of "
        + art
        + " "
        + architecture
        + " "
        + beach
        + " "
        + entertainment
        + " "
        + food
        + " "
        + hiking
        + " "
        + history
        + " "
        + mountains
        + " "
        + museum
        + " "
        + music
        + " "
        + recreation
        + " "
        + scenic_views
        + " "
        + sports
        + "respectively. I am travelling to "
        + city_name
        + " with a start date of "
        + start_date
        + " Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{landmark: landmark name, city: city, country: country, message: a short description of the landmark, tags: tags as specified above,latitude: latitude in float,longitude: longitude in float}"
    )

    try:
        completion = client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": prompt_with_input,
                }
            ],
            model="gpt-3.5-turbo",
            response_format={"type": "json_object"},
        )
        generated_text = completion.choices[0].message.content
    except Exception as e:
        return Response({"error": str(e)}, status=500)

    response_data = json.loads(generated_text)

    landmark_info = {
        "name": response_data["landmark"],
        "city": response_data["city"],
        "country": response_data["country"],
        "description": response_data["message"],
        "tags": response_data["tags"],
    }
    landmark = ""
    try:
        landmark = Landmark.objects.get(name=response_data["landmark"])
    except Landmark.DoesNotExist:
        landmark = Landmark(
            name=landmark_info["name"],
            city_name=landmark_info["city"],
            country_name=landmark_info["country"],
            description=landmark_info["description"],
        )
        landmark.save()

        for tag in landmark_info["tags"]:
            try:
                tag = Tag.objects.get(name=tag)
                landmark.tags.add(tag)
            except Tag.DoesNotExist:
                pass
        landmark.save()

    ItineraryItems.objects.create(
        it_id=itinerary,
        landmark_name=landmark,
        trip_day=day,
        latitude=response_data["latitude"],
        longitude=response_data["longitude"],
    )

    return Response(response_data)


@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_nearby_landmarks(request):

    user = request.user
    latitude = str(request.data.get("latitude"))
    longitude = str(request.data.get("longitude"))
    distance = str(request.data.get("distance"))

    tags = UserTags.objects.get(user=user)
    art = str(tags.art)
    architecture = str(tags.architecture)
    beach = str(tags.beach)
    entertainment = str(tags.entertainment)
    food = str(tags.food)
    hiking = str(tags.hiking)
    history = str(tags.history)
    mountains = str(tags.mountains)
    museum = str(tags.museum)
    music = str(tags.music)
    recreation = str(tags.recreation)
    scenic_views = str(tags.scenicViews)
    sports = str(tags.sports)

    prompt_with_input = (
        "You are a travel assistant. You will help me find nearby specific landmarks. Here is some information about me to help you. Give me at least 10 landmarks with tags of art, architecture, beach, entertainment, food, hiking, history, mountains, museum, music, recreation, scenic views, sports with ratios of "
        + art
        + " "
        + architecture
        + " "
        + beach
        + " "
        + entertainment
        + " "
        + food
        + " "
        + hiking
        + " "
        + history
        + " "
        + mountains
        + " "
        + museum
        + " "
        + music
        + " "
        + recreation
        + " "
        + scenic_views
        + " "
        + sports
        + "respectively. I am located at latitude "
        + latitude
        + ", and longitude "
        + longitude
        + "Only find me landmarks within "
        + distance
        + " kilometers of my location. Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{{landmark: landmark name, tags: tags as specified above, latitude: latitude in float, longitude: longitude in float, distance: distance from where I am in kilometers}}"
    )

    try:
        completion = client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": prompt_with_input,
                }
            ],
            model="gpt-3.5-turbo",
            response_format={"type": "json_object"},
        )
        generated_text = completion.choices[0].message.content
    except Exception as e:
        return Response({"error": str(e)}, status=500)

    response_data = json.loads(generated_text)

    # distance returned in kilometers
    return Response(response_data)


@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_itineraries(request):
    user = request.user
    user_itineraries = Itineraries.objects.filter(user=user)
    itineraries = [
        {
            "id": i.id,
            "city_name": str(i.city_name),
            "it_name": i.it_name,
            "start_date": str(i.start_date),
            # add end date?
        }
        for i in user_itineraries
    ]
    return Response({"itineraries" : itineraries})


@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_itinerary_details(request):
    user = request.user
    itinerary_id = int(request.data.get("itinerary_id"))
    itinerary = Itineraries.objects.get(id=itinerary_id)
    itinerary_items = ItineraryItems.objects.filter(it_id=itinerary)
    items = [
        {
            "it_id": i.id,
            "landmark_name": i.landmark_name.name,
            "trip_day": i.trip_day,
            "latitude": i.latitude,
            "longitude": i.longitude,
        }
        for i in itinerary_items
    ]
    return Response({"items" : items})


@api_view(["DELETE"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def remove_from_itinerary(request):
    item_id = request.data.get("id")
    try:
        item = ItineraryItems.objects.get(id=item_id)
    except ItineraryItems.DoesNotExist:
        raise NotFound("Itinerary Item not found")

    ItineraryItems.objects.get(id=item_id).delete()
    return Response(f"Itinerary Item deleted")


@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def intialize_user_preferences(request):

    user = request.user
    art = request.data.get("Art")
    architecture = request.data.get("Architecture")
    beach = request.data.get("Beach")
    entertainment = request.data.get("Entertainment")
    food = request.data.get("Food")
    hiking = request.data.get("Hiking")
    history = request.data.get("History")
    mountains = request.data.get("Mountains")
    museum = request.data.get("Museum")
    music = request.data.get("Music")
    recreation = request.data.get("Recreation")
    scenic_views = request.data.get("Scenic Views")
    sports = request.data.get("Sports")

    interests = [
        art,
        architecture,
        beach,
        entertainment,
        food,
        hiking,
        history,
        mountains,
        museum,
        music,
        recreation,
        scenic_views,
        sports,
    ]
    interests = [5 if x == 1 else 3 for x in interests]
    '''
    remain = 0
    selected = 0

    for x in interests:
        if x != 0:
            remain += max(x - 0.3, 0)
            x = min(x, 0.3)
            selected += 1
    
    to_update = 13 - selected
    for x in interests:
        if x == 0:
            x = remain / to_update
    '''

    tags = UserTags.objects.get_or_create(user=user)[0]
    # tags,created = UserTags.objects.get_or_create(username=user)
    tags.art = interests[0]
    tags.architecture = interests[1]
    tags.beach = interests[2]
    tags.entertainment = interests[3]
    tags.food = interests[4]
    tags.hiking = interests[5]
    tags.history = interests[6]
    tags.mountains = interests[7]
    tags.museum = interests[8]
    tags.music = interests[9]
    tags.recreation = interests[10]
    tags.scenicViews = interests[11]
    tags.sports = interests[12]
    tags.save()
    return Response({
        "art" : tags.art,
        "architecture" : tags.architecture,
        "beach" : tags.beach,
        "entertainment" : tags.entertainment,
        "food" : tags.food,
        "hiking" : tags.hiking,
        "history" : tags.history,
        "mountains" : tags.mountains,
        "museum" : tags.museum,
        "music" : tags.music,
        "arrecreationt" : tags.recreation,
        "scenicViews" : tags.scenicViews,
        "sports" : tags.sports
    })


@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def update_landmark_rating(request):
    user = request.user
    landmark_name = request.data.get("landmark_name")
    landmark = Landmark.objects.get(name=landmark_name)
    try:
        item = VisitedLandmarks.objects.filter(user=user).get(landmark=landmark)
    except ItineraryItems.DoesNotExist:
        raise NotFound("Landmark not found")

    item.rating = float(request.data.get("new_rating"))
    item.save()

    return Response({"Landmark Rating updated": item.rating})


@api_view(["POST"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def update_user_weights(request):
    # def update_user_weights(username):
    # all_landmarks = VisitedLandmarks.objects.filter(user=username)
    user_weights = UserTags.objects.get(user=request.user)
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
        "Sports",
    ]

    avgs = []

    for tag in tags:
        visited_landmarks = VisitedLandmarks.objects.filter(user=request.user)
        visited_landmarks_with_tag = visited_landmarks.filter(landmark__tags__name=tag)
        return Response({"valid": visited_landmarks_with_tag})
        running_sum = 0
        running_count = 0
        for landmark in visited_landmarks_with_tag:
            running_sum += landmark.rating
            running_count += 1
        if running_count == 0:
            running_sum = 3
            running_count = 1
        avgs.append(running_sum / running_count)
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
    user_weights.save()

    return Response(
        {
            "Art": user_weights.art,
            "Architecture": user_weights.architecture,
            "Beach": user_weights.beach,
            "Entertainment": user_weights.entertainment,
            "Food": user_weights.food,
            "Hiking": user_weights.hiking,
            "History": user_weights.history,
            "Mountains": user_weights.mountains,
            "Museum": user_weights.museum,
            "Music": user_weights.music,
            "Recreation": user_weights.recreation,
            "Scenic Views": user_weights.scenicViews,
            "Sports": user_weights.sports,
        }
    )


@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_destinations(request):
    all_landmarks = list(Landmark.objects.all())
    random.shuffle(all_landmarks)
    random_landmarks = all_landmarks[:6]

    landmarks_data = []
    for landmark in random_landmarks:
        tags = landmark.tags.all()
        tag_names = [tag.name for tag in tags]
        landmarks_data.append({
            "landmark_name": landmark.name,
            "city_name": landmark.city_name,
            "country_name": landmark.country_name,
            "tags": tag_names
        })

    # Create the JSON response object
    data = {"Landmarks": landmarks_data}
    return Response(data)


# @api_view(["GET"])
# @authentication_classes([SessionAuthentication, TokenAuthentication])
# @permission_classes([IsAuthenticated])
# def get_destinations(request):
#     all_cities = Landmark.objects.values_list("city_name", flat=True).distinct()
#     all_cities = list(all_cities)

#     random.shuffle(all_cities)
#     random_cities = all_cities[:6]

#     data = {"cities": random_cities}
#     return Response(data)

