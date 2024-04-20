import os
from google.cloud import vision
from pathlib import Path
from django.conf import settings
import django

from dotenv import load_dotenv
from openai import OpenAI
import json

load_dotenv()
api_key = os.getenv("API_KEY")
openai_client = OpenAI(api_key=api_key)

# Setting up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'wanderhub_backend.settings')
django.setup()

from api.models import Landmark, Tag  # Importing after setting up Django

# Set Google Cloud credentials and initialize the client
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "api/eecs-441-417520-db5559970077.json"
client = vision.ImageAnnotatorClient(
        client_options={"api_key": "AIzaSyA5vyof07KCRP1ctCnXqBeOm5xuqENix40", "quota_project_id": "eecs-441-417520"}
)

def landmark_detection(image_path):
    with open(image_path, 'rb') as image_file:
        content = image_file.read()
    image = vision.Image(content=content)
    response = client.landmark_detection(image=image)
    if len(response.landmark_annotations) != 0:
        landmark = response.landmark_annotations[0]
        return (landmark.description, image_path)
    return None

def ask_chatgpt(landmark_name):
    prompt = f"Provide detailed information for the landmark named '{landmark_name}' including its city, country, a description, and categories under tags such as Art, Architecture, Beach, Entertainment, Food, Hiking, History, Mountains, Museum, Music, Recreation, Scenic Views, Sports. Return a JSON object with the following keys: 'city', 'country', 'description', 'tags'"

    completion = openai_client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": prompt,
            }
        ],
        model="gpt-3.5-turbo",
        response_format={"type": "json_object"}
    )

    generated_text = completion.choices[0].message.content
    data = json.loads(generated_text)

    # print(data['tags'])

    if None in (data['city'], data['country'], data['description'], data['tags']):
        return None  # Return None if any field is None

    return {
        'name': landmark_name,
        'city': data['city'],
        'country': data['country'],
        'description': data['description'],
        'tags': data['tags']
    }

def save_landmark(landmark_info):
    landmark = Landmark(
        name=landmark_info['name'],
        city_name=landmark_info['city'],
        country_name=landmark_info['country'],
        description=landmark_info['description']
    )
    landmark.save()

    # print(landmark_info['tags'])

    for tag in landmark_info['tags']:
        tag, created = Tag.objects.get_or_create(name=tag)
        landmark.tags.add(tag)

    landmark.save()
    print(f"Landmark saved: {landmark}")

def process_images(directory):
    images = list(Path(directory).glob('*.jpg'))
    for image_path in images:
        landmark = landmark_detection(image_path)
        if landmark is not None and not Landmark.objects.filter(name=landmark).exists():
            landmark_info = ask_chatgpt(landmark[0])
            if landmark_info is not None:
                save_landmark(landmark_info)

if __name__ == "__main__":
    directory = "/home/ubuntu/Swifties/wanderhub_backend/images"
    process_images(directory)