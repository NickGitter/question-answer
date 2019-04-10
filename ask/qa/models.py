"""
    *** MY MODELS. ***
"""

from django.db import models
from django.contrib.auth.models import User

class Question(models.Model):
    title = models.CharField(max_length=255)
    text = models.TextField()
    added_at = models.DateTimeField(auto_now_add=True)
    rating = models.IntegerField(default=0)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    likes = models.ManyToManyField(User, related_name='question_like_user')
    def __unicode__(self):
        return self.title
    def get_absolute_url(self):
        return '/question/%d/' % self.pk
    class Meta:
        ordering = ['-added_at']


