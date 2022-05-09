from ctypes import create_unicode_buffer
from django.shortcuts import render
from django.http import HttpResponse

def default(request):
    return render(request, 'api-list.html')

def list(request):
    return HttpResponse('list users') 

def register(request):
    return HttpResponse('register user') 

def profile(request):
    return HttpResponse('user profile')

def update(request):
    return HttpResponse('update user')