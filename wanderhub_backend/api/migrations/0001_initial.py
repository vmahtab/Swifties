# Generated by Django 5.0.3 on 2024-03-24 03:27

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Landmark',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=200)),
                ('city_name', models.CharField(max_length=100)),
                ('country_name', models.CharField(max_length=100)),
                ('image_url', models.URLField()),
            ],
        ),
        migrations.CreateModel(
            name='VisitedCities',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('visit_time', models.DateTimeField()),
                ('landmark', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.landmark')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]