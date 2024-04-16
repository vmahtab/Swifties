from django.contrib import admin
from .models import Landmark, VisitedLandmarks, LandmarkIdentification, Itineraries, ItineraryItems


# Register your models here.
admin.site.register(Landmark)
admin.site.register(VisitedLandmarks)
admin.site.register(LandmarkIdentification)
admin.site.register(Itineraries)
admin.site.register(ItineraryItems)
