# Sandbox Demo
backend project for demo.isaacreyna.com

## Run App
```
docker run -it --rm -p 8000:8000  --name django isaacdanielreyna/django:0.1.0
```
Available endpoints
* `http://demo.isaacreyna.com:8000/` - Displays the list of available endpoints
* `http://demo.isaacreyna.com:8000list/` returns 'list users'
* `http://demo.isaacreyna.com:8000register/` returns 'register user'
* `http://demo.isaacreyna.com:8000profile/` returns 'user profile'
* `http://demo.isaacreyna.com:8000update/` returns 'update user'