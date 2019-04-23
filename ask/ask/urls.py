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
from qa.views import my_test, main_page, popular_page, category_page, ask_add, \
    answer_add, signup, user_login, user_logout

urlpatterns = [
    url(r'^(/)?$', main_page),
    url(r'^login(/)?$', user_login),
    url(r'^logout(/)?$', user_logout),
    url(r'^signup(/)?$', signup),
    url(r'^question\/(?P<id>\d+)(\/)$', answer_add),
    url(r'^ask(/)?$', ask_add),
    url(r'^popular(/)?$', popular_page),
    url(r'^category(/)?$', category_page),
    url(r'^new(/)?$', my_test),
    url(r'^test(/)?$', my_test),
]


