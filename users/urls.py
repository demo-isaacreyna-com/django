from django.urls import path
from . import views

# URLConf
urlpatterns = [
    path('', views.default),
    path('list/', views.list),
    path('register/', views.register),
    path('profile/', views.profile),
    path('update/', views.update),
]