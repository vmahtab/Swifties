# Generated by Django 5.0.3 on 2024-03-25 04:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_itineraries_itineraryitems'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='itineraryitems',
            name='landmark',
        ),
        migrations.AddField(
            model_name='itineraryitems',
            name='landmark_name',
            field=models.CharField(default='holder', max_length=200),
            preserve_default=False,
        ),
    ]