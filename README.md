| Video  |  Wiki |  Agile |
|:-----:|:-----:|:--------:|
|[<img src="https://eecs441.eecs.umich.edu/img/admin/video.png">][video]|[<img src="https://eecs441.eecs.umich.edu/img/admin/wiki.png">][wiki]|[<img src="https://eecs441.eecs.umich.edu/img/admin/trello.png">][agile]|

[video]: https://youtu.be/tUZliu5GloM
[wiki]: https://github.com/vmahtab/Swifties/wiki
[agile]: https://trello.com/b/YCCwAx0X/swifties

# WanderHub Native iOS Application

## Description

WanderHub is a travel application built for the iOS using Swift (SwiftUI) and Python (Django). It acts as a travel assistant by identifying landmarks submitted by users and creating custom travel itineraries for them. Users' preferences influence recommended landmarks, and users can see the past landmarks visited by them.

## Setup

Create a python virtual environment. We use `Python 3.12`. Then, install the `requirements.txt` using `pip install -r requiremens.txt`. Additionally, you will need to create a `.env` file in the outer `wanderhub_backend` folder. This folder used by the `python-dotenv` package to get secret keys. You need the following key-value pairs: `DJANGO_SECRET_KEY="{YOUR_KEY}"`, `OPENAI_API_KEY="{YOUR_KEY}"`, `GOOGLE_API_KEY="{YOUR_KEY}"`, and `GOOGLE_PROJ_ID="{YOUR_GOOGLE_PROJECT_ID}"`.

To get a **Django Secret Key** follow these steps:

(Assuming that you've already created a virtual env and installed requirements.txt)

1. Source your virtual environment. `source env/bin/activate`
2. Run `python3 manage.py shell`
3. In the shell that opens, run `from django.core.management.utils import get_random_secret_key` followed by `print(get_random_secret_key())`
4. Copy the generated secret key and into your `.env` file

**Other keys needed in the .env file need to be obtained from OpenAI or Google Cloud Platform.**

## Parameters to change

Modify the `settings.py` inside the inner `wanderhub_backend` folder. If you intend to host the Postgres database on the cloud, modify the `DATABASES` entry. Additionally, make sure that you have included a `DJANGO_SECRET_KEY` inside your .env file

Make sure that you change the `server_ip` on the frontend so that the requests are sent to your, correct server. You may want to change the `server_ip` to localhost or a real server that you may have created.

## Running the Django Server

To start the Django server, first source your virtual environment using `source env/bin/activate`. Then, run `python3 manage.py runserver` to start your server.

## Running the Frontend

Simply open the XCode.proj file by double clicking on it. Then, compile and run the code.

## Questions

Feel free to reach any contributor on this repository if you have any questions.
