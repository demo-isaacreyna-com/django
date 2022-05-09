# Sandbox Demo
backend project for demo.isaacreyna.com

## Run App
```
docker run -it --rm -p 8000:8000  --name django isaacdanielreyna/django:0.1.0
```
Available endpoints
* `/` - Displays the list of available endpoints
* `list/` returns 'list users'
* `register/` returns 'register user'
* `profile/` returns 'user profile'
* `update/` returns 'update user'