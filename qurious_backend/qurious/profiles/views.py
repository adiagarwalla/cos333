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
        user_profile = user.UserProfile

        data = serializer.serialize('json', user_profile)
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
