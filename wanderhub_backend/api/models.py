from django.db import models
from django.conf import settings
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

# Create your models here.
class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    location = models.CharField(max_length=150, blank=True)
    biography = models.TextField(blank=True)
    # profile_picture_url = models.URLField(blank=True)

    def __str__(self):
        return f"{self.user.username}'s profile"

class Tag(models.Model):
    # id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    # landmarks = models.ManyToManyField(Landmark, related_name='tags')
    # need to initialize tags

    def __str__(self):
        return f"{self.name}"

class Landmark(models.Model):
    id = models.AutoField(primary_key=True) 
    name = models.CharField(max_length=200)
    city_name = models.CharField(max_length=100)
    country_name = models.CharField(max_length=100)
    description = models.CharField(default="Unknown")
    tags = models.ManyToManyField(Tag)
    
    def __str__(self):
        return self.name

class VisitedLandmarks(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)
    visit_time = models.DateTimeField()
    rating = models.FloatField(default=3)
    image_url = models.URLField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} visited {self.landmark.city_name} on {self.visit_time}"
    
class LandmarkIdentification(models.Model):
    username = models.CharField(max_length=100, null=True, blank=True)
    timestamp = models.DateTimeField(null=True, blank=True)
    url_for_image = models.CharField(max_length=255, null=True, blank=True)
    lat = models.FloatField(default=0.0)
    lon = models.FloatField(default=0.0)
    place = models.CharField(max_length=100, default="Unknown")
    facing = models.CharField(max_length=100, default="Unknown")
    speed = models.CharField(max_length=100, default="Unknown")

    def __str__(self):
        return f"LandmarkIdentification - Username: {self.username}, Timestamp: {self.timestamp}"
    
class Itineraries(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    it_name = models.CharField(max_length=200)
    city_name = models.CharField(max_length=100)
    start_date = models.DateField()

    def __str__(self):
        return f"{self.it_name} planned for {self.user.username} in {self.city_name}"

class ItineraryItems(models.Model):
    id = models.AutoField(primary_key=True)
    it_id = models.ForeignKey(Itineraries, on_delete=models.CASCADE)
    landmark_name = models.CharField(max_length=200)
    date_time = models.DateTimeField()
    latitude = models.FloatField()
    longitude = models.FloatField()

    def __str__(self):
        return f"Visit {self.landmark.city_name} on {self.visit_time}"

class UserTags(models.Model):
    id = models.AutoField(primary_key=True) 
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, default=1)
    art = models.FloatField()
    architecture = models.FloatField()
    beach = models.FloatField()
    entertainment = models.FloatField()
    food = models.FloatField()
    hiking = models.FloatField()
    history = models.FloatField()
    mountains = models.FloatField()
    museum = models.FloatField()
    music = models.FloatField()
    recreation = models.FloatField()
    scenicViews = models.FloatField()
    sports = models.FloatField()

    def __str__(self):
        return self.user.username

# TODO: make migrations for user tags
@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)
    else:
        instance.profile.save()