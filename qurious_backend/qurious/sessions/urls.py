
from django.conf.urls import patterns, url

from qurious.sessions import views

urlpatterns = patterns('',
        url(r'^create/$', views.CreateSessionView.as_view(), name='session-create'),
        url(r'^notifications/$', views.NotificationsView.as_view(), name='notification-get-all'),
        url(r'^gettoken/$', views.GenerateToken.as_view(), name='gen-token'),
        url(r'^deletenotification/$', views.DeleteNotification.as_view(), name='delete-notif'),
        )
