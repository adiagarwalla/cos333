# Create your views here.
# This is the view that allows you to create a session
from django.views.generic import View
from django.http import HttpResponse
from qurious.sessions.forms import CreateSessionForm
from qurious.sessions.opentok_utils import create_session
from qurious.sessions.opentok_utils import generate_token
from qurious.sessions.models import Notification
from qurious.profiles.models import UserProfile
from qurious.sessions.models import QSession
from django.contrib.auth.models import User
from django.utils import simplejson

class CreateSessionView(View):
    """
    Purpose of this class is to create a session with a given
    student, teacher, and length.
    """
    def post(self, request, *args, **kwargs):
        form = CreateSessionForm(request.POST)
        if form.is_valid():
            # valid form means you have valid things to create a session
            username = request.user.username

            id_tutor = form.cleaned_data.get('teacher')
            minutes = form.cleaned_data.get('time')
            # get the UserProfile for these ids
            tutor = UserProfile.objects.get(id=id_tutor)
            user_O = User.objects.get(username=username)
            user = user_O.userprofile 
            session_id = create_session('True')
            sess = QSession(prof_tutor=tutor, prof_user=user, session_key=session_id, time=minutes)
            sess.save()

            # generate your lovely notification object
            json = simplejson.dumps({'session_id':sess.id})
            n = Notification(f=username, to=tutor, message='The user: ' + username + ' would like to have a session with you!', attachedjson=json)

            data = simplejson.dumps({'return': True})
            return HttpResponse(data, mimetype='application/json')

        return HttpResponse('', mimetype='application/json')

class NotificationsView(View):
    """
    this class will generate a notification to the given user
    """
    def get(self, request, *args, **kwargs):
        """
        This will get all the notifications for a given user
        """
        try:
            user_id = request.GET.get('id')
            user = User.objects.get(id=user_id)

            data = simplejson.dumps(user.userprofile.notifications.all())
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

    def post(self, request, *args, **kwargs):
        """
        this will delete the notification of the given id.
        """
        id = request.POST.get('id')
        notification = Notification.objects.get(id=id)
        notification.delete()
        return HttpResponse({'return': True})

class GenerateToken(View):
    """
    Purpose of this view is to generate a token given a session_token
    """
    def get(self, request, *args, **kwargs):
        try:
            session_token = request.GET.get('session_token')
            user_token = generate_token(session_token)
            data = simplejson.dumps({'token':user_token})
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

