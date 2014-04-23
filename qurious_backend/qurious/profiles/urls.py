from django.conf.urls import patterns, url

from qurious.profiles import views

urlpatterns = patterns('',
        url(r'^profile/$', views.profileIOSDetailView.as_view(), name='profile-detail'),
        url(r'^skills/$', views.skillIOSView.as_view(), name='skill-view'),
        url(r'^allprofiles/$', views.ProfileIOSAllView.as_view(), name='all-profile'),
        url(r'^allskills/$', views.SkillIOSAllView.as_view(), name='all-skills'),
        url(r'^delete/$', views.DeleteSkillIOSView.as_view(), name='delete-skill'),
        url(r'^whoami/$', views.WhoAmIView.as_view(), name='whoami'),
        )
