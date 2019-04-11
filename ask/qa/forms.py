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


