# Create your views here.

from django.views.generic import View
from django.utils import simplejson
from django.http import HttpResponse
from django.contrib.auth.models import User
from django.core import serializers
from qurious.profiles.forms import ProfileEditForm
from qurious.profiles.forms import SkillEditForm

from qurious.profiles.models import Skill
from qurious.profiles.models import UserProfile
from qurious.profiles.models import ProfileImage
from qurious.profiles.forms import UploadFileForm

class profileIOSDetailView(View):
    """
    This is the view for a profile. This will get you all of
    the fields attached to a profile (username, email, skills, etc...)
    """
    def get(self, request, *args, **kwargs):
        """
        get a profile; returns an empty string if id is invalid
        """
        id = request.GET.get('id')
        try:
            user = User.objects.get(id=id)
            data = serializers.serialize('json', [user.userprofile])
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

    def post(self, request, *args, **kwargs):
        form = ProfileEditForm(request.POST)
        if form.is_valid():
            username = request.user.username
            user = User.objects.get(username=username)
            user_prof = user.userprofile
            user_prof.profile_name = form.cleaned_data.get('profile_name')
            user_prof.user_bio = form.cleaned_data.get('user_bio')
            user_prof.user_email = form.cleaned_data.get('user_email')
            user_prof.profile_first = form.cleaned_data.get('profile_first')
            user_prof.profile_last = form.cleaned_data.get('profile_last')
            user_prof.save()

            data = simplejson.dumps({'return': True})
            return HttpResponse(data, mimetype='application/json')

        return HttpResponse('', mimetype='application/json')

class ImageView(View):
    """
    Uploads the image
    """
    def post(self, request, *args, **kwargs):
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            # QUESTIONABLE CODE, THIS NEEDS TO BE FUCKING CHANGED
            id = request.POST.get('id')
            user = User.objects.get(id=id)
            userprof = user.userprofile
            userprof.profile_pic = request.FILES['file']
            userprof.save()

            data = simplejson.dumps({'return': True})
            return HttpResponse(data, mimetype='application/json')

        return HttpResponse('', mimetype='application/json')

class ProfileIOSAllView(View):
    """
    This view returns all of the profiles in the db
    """
    def get(self, request, *args, **kwargs):
        profiles = UserProfile.objects.filter()

        json = '['
        for profile in profiles:
            p = '{"profile":' + serializers.serialize('json', [profile]) + ',"skills":' + serializers.serialize('json', profile.skills.all()) + '}'
            json = json + p + ','

        json = json[0:len(json) -1]
        json = json + ']'

        #data = simplejson.dumps(json)
        return HttpResponse(json, mimetype='application/json')

class skillIOSView(View):
    """
    This is a view for a skill. It will get you the fields associated
    with a skill (price, description, name, etc)
    """
    def get(self, request, *args, **kwargs):
        import pdb; pdb.set_trace()
        try:
            id = request.GET.get('id')
            skill = Skill.objects.get(id=id)

            data = serializers.serialize('json', [skill])
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

    def post(self, request, *args, **kwargs):
        form = SkillEditForm(request.POST)

        if form.is_valid():
            skill_id = form.cleaned_data.get('skill_id')
            if skill_id == 0:
                skill = Skill(name=form.cleaned_data.get('name'), price=form.cleaned_data.get('price'), desc=form.cleaned_data.get('desc'), is_marketable=bool(form.cleaned_data.get('marketable')))
                skill.save()
                username = request.user.username
                user = User.objects.get(username=username)
                user.userprofile.skills.add(skill)
            else:
                skill = Skill.objects.get(id=skill_id)
                skill.price = form.cleaned_data.get('price')
                skill.desc = form.cleaned_data.get('desc')
                skill.is_marketable = bool(form.cleaned_data.get('marketable'))

            data = simplejson.dumps({'return': True})
            return HttpResponse(data, mimetype='application/json')

        return HttpResponse('', mimetype='applicaton/json')

class DeleteSkillIOSView(View):
    """
    This is the view that deals with deleting skills
    """
    def get(self, request, *args, **kwargs):
        id = request.GET.get('id')
        try:
            skill = Skill.objects.get(id=id)
            skill.delete()
            data = simplejson.dumps({'return': True})
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

class SkillIOSAllView(View):
    """
    The view for all the skills coming back
    """
    def get(self, request, *args, **kwargs):
        try:
            user_id = request.GET.get('id')
            user = User.objects.get(id=user_id)
            skills = user.userprofile.skills.all()

            data = serializers.serialize('json', skills)
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

class WhoAmIView(View):
    """
    Check who you are at any given time
    """
    def get(self, request, *args, **kwargs):
        try:
            username = request.user.username
            user_id = User.objects.get(username=username).id

            data = serializers.serialize('json', {'user_id':user_id})
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

class SetPushToken(View):
    """
    Set phone token for push notifications
    """
    def post(self, request, *args, **kwargs):
        username = request.user.username
        user = User.objects.get(username=username)
        user_profile = user.userprofile
        user_profile.token = request.POST.get('token')
        user_profile.save()
        
        data =  simplejson.dumps({'return': True})
        return HttpResponse(data, mimetype='application/json')
