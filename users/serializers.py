from rest_framework import serializers
from users.models import User
from hashlib import sha256

class UserSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=255)
    first_name = serializers.CharField(max_length=255)
    last_name = serializers.CharField(max_length=255)
    password = serializers.CharField(max_length=255)

    def validate(self, data):
        h = sha256()
        h.update(data['password'].encode('utf-8'))
        data['password'] = h.hexdigest()
        return data

    def create(self, validated_data):
        user = User(**validated_data)
        user.save()
        return user