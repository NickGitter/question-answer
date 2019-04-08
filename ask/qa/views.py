"""
    *** MY VIEWS. ***
"""

from django.shortcuts import render
from django.http import HttpResponse

def my_test(request, *args, **kwargs):
    return HttpResponse('ok')


