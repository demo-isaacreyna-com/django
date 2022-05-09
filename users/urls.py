from django.urls import path
from . import views

# URLConf
urlpatterns = [
    path('', views.default),
    path('list/', views.list),
    path('register/', views.register),
    path('profile/<username>/', views.profile),
    path('delete/<username>', views.delete),
]