# Sandbox Demo
backend project for demo.isaacreyna.com

## Run App
```
docker run -it --rm -p 8000:8000  --name django isaacdanielreyna/django:0.1.0
```
Available endpoints
* `http://demo.isaacreyna.com:8000/`  
    Displays the list of available endpoints

* `http://demo.isaacreyna.com:8000/list/`  
    This endpoint returns the list of users.
    ```json
    [
        {
            "username": "jsmith",
            "first_name": "John",
            "last_name": "Smith",
            "password": "0a041b9462caa4a31bac3567e0b6e6fd9100787db2ab433d96f6d178cabfce90"
        },
        {
            "username": "jdoe",
            "first_name": "Jane",
            "last_name": "Doe",
            "password": "6025d18fe48abd45168528f18a82e265dd98d421a7084aa09f61b341703901a3"
        },
        {
            "username": "wsmith",
            "first_name": "Will",
            "last_name": "Smith",
            "password": "5860faf02b6bc6222ba5aca523560f0e364ccd8b67bee486fe8bf7c01d492ccb"
        },
        {
            "username": "crock",
            "first_name": "Chris",
            "last_name": "Rock",
            "password": "5269ef980de47819ba3d14340f4665262c41e933dc92c1a27dd5d01b047ac80e"
        }
    ]
    ```
* `http://demo.isaacreyna.com:8000/profile/jsmith/`  
    returns the given user

* `http://demo.isaacreyna.com:8000/delete/jsmith`  
    Pressing the delete button will delete the user associated with the given username.

* `http://demo.isaacreyna.com:8000/register/`  
    To add a user add a json object with the following format into the Content field and press the POST button.
    ```json
    {
        "username": "jsmith",
        "first_name": "John",
        "last_name": "Smith",
        "password": "abc123"
    }
    ```