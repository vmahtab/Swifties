# Generated by Django 5.0.3 on 2024-04-22 01:47

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='itineraryitems',
            name='landmark_name',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='api.landmark'),
        ),
    ]