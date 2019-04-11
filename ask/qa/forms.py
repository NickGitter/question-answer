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


