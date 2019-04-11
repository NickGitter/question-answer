"""
    *** MY VIEWS. ***
"""

from django.shortcuts import render, get_object_or_404
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

def one_question(request, id):
    question = get_object_or_404(Question, id=id)
    try:
        answers = Answer.objects.filter(question=question)
        answers = answers.order_by('-added_at')
        answers = answers[0:]
    except Answer.DoesNotExist:
        answers = []
    return render(request, 'one_question.html', {
        'title': question.title,
        'text': question.text,
        'answers': answers,
    })


