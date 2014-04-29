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
    datetime_created = models.DateTimeField(auto_now_add=True)

    def delete(self):
        """
        Custom delete for the Notification object, so that it releases a push
        notification on delete
        """
        token_to = self.to.token
        token_from = self.f.token

        token_to = token_to.replace('<','')
        token_to = token_to.replace('>','')
        token_to = token_to.replace(' ', '')
        device = iPhone.objects.filter(udid=token_to)
        if len(device) == 0:
            device = iPhone(udid=token_to)
            device.save()
        else:
            device = device[0]

        device.send_message("Session request has been cancelled")
        token_from = token_from.replace('<', '')
        token_from = token_from.replace('>', '')
        token_from = token_from.replace(' ', '')
        device = iPhone.objects.filter(udid=token_from)
        if len(device) == 0:
            device = iPhone(udid=token_from)
            device.save()
        else:
            device = device[0]

        device.send_message("Session request has been cancelled")
        super(Notification, self).delete()

