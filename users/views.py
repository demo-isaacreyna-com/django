from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import User
from .serializers import UserSerializer

def default(request):
    return render(request, 'api-list.html')

@api_view()
def list(request):
    queryset = User.objects.all()
    serializer = UserSerializer(queryset, many=True)
    return Response(serializer.data) 

@api_view(['GET', 'POST'])
def register(request):
    if request.method == 'GET':
        return Response('ok')
    if request.method == 'POST':
        serializer = UserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response('ok')

@api_view()
def profile(request, username):
    user = get_object_or_404(User, username=username)
    serializer = UserSerializer(user)
    return Response(serializer.data)

@api_view(['GET', 'POST', 'DELETE'])
def delete(request, username):
    user = get_object_or_404(User, username=username)
    
    if request.method == 'GET':
        return Response('ok')
    if request.method == 'DELETE':
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
