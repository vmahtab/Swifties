from rest_framework import serializers
from django.contrib.auth.models import User
from .models import LandmarkIdentification

class UserSerializer(serializers.ModelSerializer):
    class Meta(object):
        model = User
        fields = ['id', 'username', 'password', 'email']

class ImageDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = LandmarkIdentification
        fields = ['username', 'timestamp', 'url_for_image', 'lat', 'lon', 'place', 'facing', 'speed']