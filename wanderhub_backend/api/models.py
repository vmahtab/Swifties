from django.db import models
from django.conf import settings

# Create your models here.
class Landmark(models.Model):
    id = models.AutoField(primary_key=True) 
    name = models.CharField(max_length=200)
    city_name = models.CharField(max_length=100)
    country_name = models.CharField(max_length=100)
    image_url = models.URLField(max_length=200)
    

    def __str__(self):
        return self.name

class VisitedCities(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    landmark = models.ForeignKey(Landmark, on_delete=models.CASCADE)
    visit_time = models.DateTimeField()

    def __str__(self):
        return f"{self.user.username} visited {self.landmark.city_name} on {self.visit_time}"