from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Skill(models.Model):

    name = models.CharField(max_length=64)
    desc = models.CharField(max_length=200)
    price = models.IntegerField()
    is_marketable  = models.BooleanField()

class UserProfile(models.Model):

    user = models.OneToOneField(User)
    profile_first = models.CharField(max_length=256)
    profile_pic = models.FileField(upload_to='files/')
    profile_last = models.CharField(max_length=256)
    profile_name = models.CharField(max_length=256)
    user_email = models.CharField(max_length=256)
    user_bio = models.CharField(max_length=200)
    skills = models.ManyToManyField(Skill, null=True)

class ProfileImage(models.Model):

    file = models.FileField(upload_to='files/')

