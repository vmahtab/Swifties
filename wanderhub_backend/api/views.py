from rest_framework.decorators import api_view
from rest_framework.response import Response

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

from openai import ChatCompletion
api_key = "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"
chat_completion = ChatCompletion(api_key)


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
    itinerary_prompt = '''\You are a travel assistant. You will help me write a customized travel itinerary with only specific landmarks.
      Here is some information about me to help you
      {interests}
      I am travelling to {city_name}, {country_name}
      with dates from {start_date} to {end_date}
      Based on this information, please provide me an itinerary in a json format with date, time, specific landmark, latitude and longitude'''
    
    interests = request.data.get('interests', '')
    city_name = request.data.get('city_name', '')
    country_name = request.data.get('country_name', '')
    start_date = request.data.get('start_date', '')
    end_date = request.data.get('end_date', '')

    try:
        prompt_with_input = itinerary_prompt.format(interests=interests, city_name=city_name, country_name=country_name, start_date=start_date, end_date=end_date)
        response = chat_completion.create_chat_completion(prompt=prompt_with_input)
        generated_text = response.choices[0].text.strip()
    except Exception as e:
        return Response({'error': str(e)}, status=500)

        # Return the generated response
    return Response({'response': generated_text})


@api_view(["GET"])
@authentication_classes([SessionAuthentication, TokenAuthentication])
@permission_classes([IsAuthenticated])
def get_user_itineraries(request):
    user = request.user
    user_itineraries = Itineraries.objects.filter(user=user).select_related('it_name')
    itineraries = [{"city_name": i.city_name, "it_name": i.it_name, "start_date": i.start_date.strftime("%Y-%m-%d")} 
                      for i in itineraries]
    return Response(itineraries)

@api_view(["POST"])
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
    