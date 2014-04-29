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
from push_notifications.models import APNSDevice
from iphonepush.models import iPhone

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
            tutor = User.objects.get(id=id_tutor)
            tutor = tutor.userprofile
            user_O = User.objects.get(username=username)
            user = user_O.userprofile 
            session_id = create_session('True')
            sess = QSession(prof_tutor=tutor, prof_user=user, session_key=session_id, time=minutes)
            sess.save()

            # generate your lovely notification object
            json = simplejson.dumps({'session_id': session_id})
            n = Notification(f=username, to=tutor, message='The user: ' + username + ' would like to have a session with you!', attachedjson=json)
            n.save()
            token = tutor.token
            # we need to be able to create one of these APNS device tokens if one doesn't exist and send a notif
            token = token.replace('<','')
            token = token.replace('>','')
            token = token.replace(' ', '')
            device = iPhone.objects.filter(udid=token)
            if len(device) == 0:
                device = iPhone(udid=token)
                device.save()
            else:
                device = device[0]

            device.send_message("Someone wants to have a session with you")

            data = simplejson.dumps({'session_id': session_id})
            return HttpResponse(data, mimetype='application/json')

        return HttpResponse('', mimetype='application/json')

class DeleteNotification(View):
    """
    This View will delete the notification object, essentially removing the session
    Although, the session will never actually be removed
    """
    def post(self, request, *args, **kwargs):
        id = request.POST.get('id')
        username = request.user.username
        user = User.objects.get(username=username)
        for n in user.userprofile.notification_set.all():
            if n.id == id:
                n.delete()
                data = simplejson.dumps({'return':True})
                return HttpResponse(data, mimetype='application/json')

        data = simplejson.dumps({'return':False})
        return HttpResponse(data, mimetype='application/json')

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

            data = simplejson.dumps(user.userprofile.notification_set.all())
            return HttpResponse(data, mimetype='application/json')
        except:
            return HttpResponse('', mimetype='application/json')

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

