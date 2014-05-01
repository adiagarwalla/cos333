from django_cron import cronScheduler, Job

# This is a function I wrote to check a feedback email address and add it to our database. Replace with your own imports
from datetime import datetime, timedelta
#from qurious.sessions.models import Notification
from background_task import background
from django.core.mail import send_mail
from qurious.sessions.models import Notification
import smtplib

class Cron(Job):

        # run every 300 seconds (5 minutes)
        run_every = 60 
        def job(self):
            print 'reached here'
            time_threshold = datetime.now() - timedelta(minutes=1)
            results = Notification.objects.filter(datetime_created__lt=time_threshold)
            for r in results:
                r.is_expired = True
                r.save()
            fromaddr = 'qurious@gmail.com'
            toaddrs  = 'abhi1994@gmail.com'
            msg = 'There was a terrible error that occured and I wanted you to know!'
            # Credentials (if needed)
            username = 'abhi1994@gmail.com'
            password = 'good2dad'
            # The actual mail send
            server = smtplib.SMTP('smtp.gmail.com:587')
            server.starttls()
            server.login(username,password)
            server.sendmail(fromaddr, toaddrs, msg)
            server.quit()

cronScheduler.register(Cron)
