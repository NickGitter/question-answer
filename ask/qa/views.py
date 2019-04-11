"""
    *** MY VIEWS. ***
"""

from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, Http404, HttpResponseRedirect
from django.views.decorators.http import require_GET
from django.core.paginator import Paginator

from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout

from qa.models import Question, Answer
from qa.forms import AskForm, AnswerForm, SignupForm, LoginForm

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

def ask_add(request, *args, **kwargs):
    user = request.user
    if request.method == "POST":
        form = AskForm(request.POST)
        if form.is_valid():
            question = form.save(user)
            url = question.get_absolute_url()
            return HttpResponseRedirect(url)
    else:
        form = AskForm()
        return render(request, 'ask_add.html', {
            'form': form
        })

# The question page with form for added an answer.
def answer_add(request, id):
    user = request.user
    question = get_object_or_404(Question, id = id)
    if request.method == "POST":
        form = AnswerForm(request.POST)
        if form.is_valid() == True:
            answer = form.save(question, user)
            url = '/question/%d/' % int(id)
            return HttpResponseRedirect(url)
        if form.is_valid() == False:
            return HttpResponse('200')
    else:
        try:
            answers = Answer.objects.filter(question = question)
            answers = answers.order_by('-added_at')
            answers = answers[0:]
        except Answer.DoesNotExist:
            answers = []
        form = AnswerForm( initial={'question': question.id} )
        return render(request, 'one_question.html', {
            'id': id,
            'title': question.title,
            'text': question.text,
            'author': question.author,
            'answers': answers,
            'form': form,
        })

def signup(request, *args, **kwargs):
    if request.method == "POST":
        form = SignupForm(request.POST)
        if form.is_valid() == True:
            form.save()
            my_username = form.cleaned_data['username']
            my_password = form.cleaned_data['password']
            user = authenticate(username=my_username, password=my_password)
            login(request, user)
            print('User %s is created!' % my_username)
            url = '/'
            return HttpResponseRedirect(url)
        else:
            return render(request, 'signup.html', {
            'form': form,
        })
    else:
        form = SignupForm()
        return render(request, 'signup.html', {
            'form': form,
        })


