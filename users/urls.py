from django.urls import path
from . import views

# URLConf
urlpatterns = [
    path('api/', views.default),
    path('api/list/', views.list),
    path('api/register/', views.register),
    path('api/profile/<username>/', views.profile),
    path('api/delete/<username>', views.delete),
]