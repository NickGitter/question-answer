"""
    *** MY VIEWS. ***
"""

from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.http import require_GET

from qa.models import Question, Answer

def my_test(request, *args, **kwargs):
    return HttpResponse('ok')

@require_GET
def main_page(request, *args, **kwargs):
    questions = Question.objects.new()
    return render(request, 'list_of_questions.html', {
        'questions': questions,
    })

@require_GET
def popular_page(request, *args, **kwargs):
    questions = Question.objects.popular()
    return render(request, 'list_of_questions.html', {
        'questions': questions,
    })


