# Create your views here.

from django.views.generic import View
from django.utils import simplejson
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.core import serializers
from qurious.profiles.forms import ProfileEditForm

class profileIOSDetailView(View):
    """
    This is the view for a profile. This will get you all of
    the fields attached to a profile (username, email, skills, etc...)
    """
    def get(self, request, *args, **kwargs):

        id = request.GET.get('id')
        user = User.objects.get(id=id)
        user_profile = user.userprofile

        data = serializers.serialize('json', [user_profile])
        return HttpResponse(data, mimetype='application/json')

    def post(self, request, *args, **kwargs):
        form = ProfileEditForm(request.POST)

        if form.is_valid():
            username = request.user.username
            user = User.objects.get(username=username)
            user_prof = user.userprofile
            user_prof.profile_name = form.cleaned_data.get('profile_name')
            user_prof.user_bio = form.cleaned_data.get('user_bio')
            user_prof.user_email = form.cleaned_data.get('user_email')
            user_prof.save()

            data = simplejson.dumps({True})
            return HttpResponse(data, mimetype='application/json')

        data = simplejson.dumps({False})
        return HttpResponse(data, mimetype='application/json')

class skillIOSView(View):
    """
    This is a view for a skill. It will get you the fields associated
    with a skill (price, description, name, etc)
    """
    def get(self, request, *args, **kwargs):

        id = request.GET.get('id')
        skill = Skill.objects.get(id=id)

        data = serializers.serialize('json', [skill])
        return HttpResponse(data, mimetype='application/json')

    def post(self, request, *args, **kwargs):
        form = SkillEditForm(request.POST)

        if form.is_valid():
            skill_id = form.clean_data.get('skill_id')
            skill = Skill.objects.get(id=skill_id)
            skill.price = form.clean_data.get('price')
            skill.desc = form.clean_data.get('desc')
            skill.is_marketable = bool(form.clean_data.get('marketable'))

            data = simplejson.dumps({True})
            return HttpResponse(data, mimetype='application/json')

        data = simplejson.dumps({False})
        return HttpResponse(data, mimetype='applicaton/json')
