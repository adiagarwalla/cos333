from django.conf.urls import patterns, include, url
import django_cron
django_cron.autodiscover()

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'qurious.views.home', name='home'),
    # url(r'^qurious/', include('qurious.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    url(r'^api-profile/', include('qurious.profiles.urls')),
    url(r'^api-auth/', include('qurious.auth.urls')),
    url(r'^api-session/', include('qurious.sessions.urls')),
)
