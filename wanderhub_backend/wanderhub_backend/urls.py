"""
URL configuration for wanderhub_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path, re_path
from api import views, landmarks

urlpatterns = [
    path("admin/", admin.site.urls),
    
    path('login', views.login),
    path('signup', views.signup),
    path('add-user-landmark', views.add_user_landmark),
    path('get-user-landmarks', views.get_user_landmarks),
    path('make-custom-itinerary', views.make_custom_itinerary),
    path('get-user-itineraries', views.get_user_itineraries),
    path('remove-from-itinerary', views.remove_from_itinerary),
    path('test_token', views.test_token),

    path('post_landmarks', landmarks.post_landmarks),
    path('get_landmarks', landmarks.get_landmark),
]
