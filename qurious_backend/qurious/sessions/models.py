from django.db import models
from qurious.profiles.models import UserProfile

# Create your models here.
class QSession(models.Model):
    # session object, what exactly does it need?
    # perhaps it needs, a tutor, student, length, session_token
    prof_tutor = models.ForeignKey(UserProfile)
    prof_user = models.ForeignKey(UserProfile, related_name='prof_tutee')
    time = models.IntegerField()
    session_key = models.TextField()

class Notification(models.Model):
    f = models.CharField(max_length=256)
    to = models.ForeignKey(UserProfile)
    message = models.CharField(max_length=512)
    attachedjson = models.CharField(max_length=512)
