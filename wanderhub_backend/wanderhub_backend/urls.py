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
from api import views, landmarks, combine

urlpatterns = [
    path("admin/", admin.site.urls),
    
    path('login/', views.login),
    path('signup/', views.signup),
    path('add-user-landmark/', views.add_user_landmark),
    path('get-user-landmarks/', views.get_user_landmarks),
    path('make-custom-itinerary/', views.make_custom_itinerary),
    path('add-to-itinerary/', views.add_to_itinerary),
    path('get-nearby-landmarks/', views.get_nearby_landmarks),
    path('get-user-itineraries/', views.get_user_itineraries),
    path('get-itinerary-details/', views.get_itinerary_details),
    path('remove-from-itinerary/', views.remove_from_itinerary),
    path('test_token/', views.test_token),

    path('intialize-user-preferences/', views.intialize_user_preferences),

    path('post_landmarks/', landmarks.post_landmarks),
    path('get_landmarks/', landmarks.get_landmark),
    path('post_landmark_info/', landmarks.post_landmark_info),
    path('post_landmark_id_and_info/', combine.post_landmark_id_and_info),

    path('testing_intialize_user_preferences', views.intialize_user_preferences),
    path('testing_update_landmark_rating', views.update_landmark_rating),
    path('testing_update_user_weights', views.update_user_weights)
]
