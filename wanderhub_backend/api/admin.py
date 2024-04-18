from django.contrib import admin
from .models import UserProfile, Tag, Landmark, VisitedLandmarks, LandmarkIdentification, Itineraries, ItineraryItems, UserTags


# Register your models here.
admin.site.register(UserProfile)
admin.site.register(Tag)
admin.site.register(Landmark)
admin.site.register(VisitedLandmarks)
admin.site.register(LandmarkIdentification)
admin.site.register(Itineraries)
admin.site.register(ItineraryItems)
admin.site.register(UserTags)