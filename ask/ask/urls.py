"""ask URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
#from django.conf.urls import path
from django.conf.urls import url, include
from qa.views import my_test, main_page, popular_page, one_question

urlpatterns = [
    url(r'^(/)?$', main_page),
    url(r'^login(/)?$', my_test),
    url(r'^logout(/)?$', my_test),
    url(r'^signup(/)?$', my_test),
    url(r'^question\/(?P<id>\d+)(\/)$', one_question),
    url(r'^ask(/)?$', my_test),
    url(r'^popular(/)?$', popular_page),
    url(r'^new(/)?$', my_test),
    url(r'^test(/)?$', my_test),
]


