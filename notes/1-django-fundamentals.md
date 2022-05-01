# Django Fundamentals
The D is silent

## Install django
This creates a virtual environment
```
mkdir storefront
cd storefront
pipenv install django
```

## Activate the virtual environment
Uses the python interpreter inside the virtual environment, not the one installed globally on this machine
```
pipenv shell
```

## Start a new project
Use django-admin to start a new project. This is a utility that comes with django which provides several commands to work with django project.
```
django-admin startproject storefront .
```

Now going forward use `python manage.py` instead of `django-admin`. This is a wrapper around `django-admin`, and takes the settings of this project into account.

## Run the server
Providing a port number is optional, and port 8000 will be used by default.
`python manage.py runserver 8000`

## Visit front-end
Navigate to localhost:8000

# Setting up vscode terminal to use python interpreter
VSCode will automatically activate the virtual environment for this project
1. Copy the path to the virtual environment shown by using `pipenv --venv`
1. Press `Shift + Command + P` to bring up the command pallet.
1. Search for `python interpreter`
1. Select `Python: Select Interpreter`
1. Select `Enter interpreter path...`
1. Paste the path in and append `/bin/python`
1. Press Enter

Once in a while you'll get the message `SyntaxError: invalid syntax`. Just open a new terminal to fix that.

# Apps
See the `storefront/settings.py` module. By default every django project includes the following app
```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```
## Creating a new app
Use the following command to create new app
```
python manage.py startapp playground
```

Register the newly created app in the settings module
```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'playground',
]
```

# Views
Views are request handlers, and they are defined in `views.py`.

```python
from django.shortcuts import render
from django.http import HttpResponse


def say_hello(request):
    return HttpResponse('Hello World') 
```

## Mapping URLs to a views
Create a file `playground/urls.py`
```python
from django.urls import path
from . import views

# URLConf
urlpatterns = [
    path('hello/', views.say_hello)
]
```
Edit `storefront/urls.py` to add the new URLConf for playground.
```python
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('playground/', include('playgrounds.urls'))
]
```

# Templates
Templates are your html content displays (known as views in other frameworks)

Create the file `playground/templates/hello.html`
```html
<h1>Hello World</h1>
```

Edit file `playground/views.py` and change the return in `say_hello` to the following shown below.
```python
from django.shortcuts import render
from django.http import HttpResponse


def say_hello(request):
    return render(request, 'hello.html')
```

We can pass variables and use logic  

`playground/views.py`
```python
from django.shortcuts import render
from django.http import HttpResponse


def say_hello(request):
    return render(request, 'hello.html', { 'name': 'Isaac'})

```
`playground/templates/hello.html`
```html
{% if name %}
<h1>Hello {{ name }}</h1>
{% else %}
<h1>Hello World</h1>
{% endif %}
```
