from django.conf.urls import patterns, url

from qurious.profiles import views

urlpatterns = patterns('',
        url(r'^profile/$', views.profileIOSDetailView.as_view(), name='profile-detail'),
        url(r'^skills/$', views.skillIOSView.as_view(), name='skill-view'),
        )
