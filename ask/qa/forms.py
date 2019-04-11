"""
    *** MY FORMS. ***
"""

from django import forms
from django.contrib.auth.models import User

from qa.models import Question, Answer

class AskForm(forms.Form):
    title = forms.CharField(max_length=254)
    text = forms.CharField(widget=forms.Textarea)
    
    def __init__(self, *args, **kwargs):
        super(AskForm, self).__init__(*args, **kwargs)
    
    def clean(self):
        return self.cleaned_data
    
    def clean_title(self):
        title = self.cleaned_data['title']
        return title
    
    def clean_text(self):
        text = self.cleaned_data['text']
        return text
    
    def save(self, user):
        self.cleaned_data['author'] = user
        question = Question(**self.cleaned_data)
        question.save()
        return question

class AnswerForm(forms.Form):
    text = forms.CharField(widget=forms.Textarea)
    question = forms.IntegerField(
        widget=forms.HiddenInput(), initial=0) # Hidden field.
    
    def __init__(self, *args, **kwargs):
        super(AnswerForm, self).__init__(*args, **kwargs)
    
    def clean(self):
        return self.cleaned_data
    
    def clean_text(self):
        text = self.cleaned_data['text']
        return text
    
    def clean_question(self):
        question = self.cleaned_data['question']
        return question
    
    def save(self, question, user):
        self.cleaned_data['author'] = user
        self.cleaned_data['question'] = question
        answer = Answer(**self.cleaned_data)
        answer.save()
        return answer

class SignupForm(forms.Form):
    username = forms.CharField(max_length=100)
    email = forms.EmailField(max_length=100)
    password = forms.CharField(widget=forms.PasswordInput, max_length=254)
    
    def clean(self):
        uname = self.cleaned_data['username']
        check = False
        try:
            User.objects.get(username=uname)
        except User.DoesNotExist:
            check = True
        if check == False:
            raise forms.ValidationError('User %s is existing!' % uname)
        uemail = self.cleaned_data['email']
        check = False
        try:
            User.objects.get(email=uemail)
        except User.DoesNotExist:
            check = True
        except User.MultipleObjectsReturned:
            check = False
        if check == False:
            raise forms.ValidationError('Email %s already used!' % uemail)
        return self.cleaned_data
    
    def clean_username(self):
        username = self.cleaned_data['username']
        return username
    
    def clean_email(self):
        email = self.cleaned_data['email']
        return email
    
    def clean_password(self):
        password = self.cleaned_data['password']
        return password
    
    def save(self):
        user = User.objects.create_user(**self.cleaned_data)
        user.save()
        return user


