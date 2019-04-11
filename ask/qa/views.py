"""
    *** MY VIEWS. ***
"""

from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, Http404
from django.views.decorators.http import require_GET
from django.core.paginator import Paginator

from qa.models import Question, Answer

# Function for abstract pagination.
def my_paginate(request, QuerySet):
    limit = 10
    try:
        page = int( request.GET.get('page', 1) )
    except ValueError:
        raise Http404
    paginator = Paginator(QuerySet, limit)
    try:
        page = paginator.page(page)
    except EmptyPage:
        page = paginator.page(paginator.num_pages)
    return page

def my_test(request, *args, **kwargs):
    return HttpResponse('ok')

@require_GET
def main_page(request, *args, **kwargs):
    questions = Question.objects.new()
    page = my_paginate(request, questions)
    paginator = page.paginator
    paginator.baseurl = '/?page='
    return render(request, 'list_of_questions.html', {
        'questions': page.object_list,
        'paginator': paginator,
        'page': page,
    })

@require_GET
def popular_page(request, *args, **kwargs):
    questions = Question.objects.popular()
    page = my_paginate(request, questions)
    paginator = page.paginator
    paginator.baseurl = '/popular/?page='
    return render(request, 'list_of_questions.html', {
        'questions': page.object_list,
        'paginator': paginator,
        'page': page,
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
        'id': id,
        'title': question.title,
        'text': question.text,
        'author': question.author,
        'answers': answers,
    })


