from django.conf.urls import patterns, url

from qurious.auth import views

urlpatterns = patterns('',
        url(r'^login/$', views.QuriousLoginView.as_view(), name='login'),
        url(r'^logout/$', views.QuriousLogoutView.as_view(), name='logout'),
        url(r'^signup/$', views.QuriousSignUpView.as_view(), name='signup'),
        )
