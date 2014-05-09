"""
This file demonstrates writing tests using the unittest module. These will pass
when you run "manage.py test".

Replace this with more appropriate tests for your application.
"""

from django.test import TestCase
from django.test.client import Client
from django.contrib.auth.models import User
from qurious.profiles.models import UserProfile
from qurious.profiles.models import Skill
from django.core.urlresolvers import reverse
from qurious.sessions.opentok_utils import create_session

def create_user(user_name):
    user_dummy = User(username=user_name, email='sam@sam.com')
    user_dummy.set_password('123')
    user_dummy.save()
    user_dummy_profile = UserProfile(user=user_dummy, profile_name='cheng', user_email=user_dummy.email, user_bio='1234i love cheng')

    #  dummmy skill needs to be created
    s = Skill(name='learning', desc='i love cheng desks', price=123445, is_marketable=True)

    user_dummy_profile.save()
    s.save()
    user_dummy_profile.skills.add(s)
    user_dummy_profile.save()

class SimpleTest(TestCase):
    def test_basic_addition(self):
        """
        Tests that 1 + 1 always equals 2.
        """
        self.assertEqual(1 + 1, 2)

class SessionTests(TestCase):
    def test_create_session(self):
        """
        Tests the creation of a new session, ensures that the proper json is returned
        ensures that the session actually got created, and with the
        proper data.
        """
        # we need to set up two different users
        c = Client()
        create_user('sam1')
        create_user('sam')

        self.client.login(username='sam1', password='123')
        response = c.post(reverse('session-create'), {'time':15,'teacher':1})
        self.assertTrue(response.content != '')

        # failure portion
        response = c.post(reverse('session-create'), {'time':'fail','teacher':'c'})
        self.assertTrue(response.content == '')

    def test_generate_token(self):
        """
        Tests if tokens can be generated and returned given
        """
        session_token = create_session('True')
        c = Client()
        response = c.get(reverse('gen-token') + '?session_token=' + session_token)

        self.assertTrue(response.status_code == 200)
        self.assertTrue(response.content != '')

        # failure case
        response = c.get(reverse('gen-token') + '?failure')
        self.assertTrue(response.content == '')

    def test_get_notification(self):
        c = Client()
        create_user('sam1')
        create_user('sam')
        
        response = c.get(reverse('notifications'))
        self.assertTrue(response.content == '')

        c.post(reverse('login'), {'username':'sam1', 'password':'123'})
        response = c.get(reverse('notifications'))
        self.assertTrue(response.status_code == 200)
        self.assertTrue(response.content != '')

    def test_notification_delete(self):
        c = Client()
        create_user('sam1')
        create_user('sam')

        self.client.login(username='sam1', password='123')
        response = c.get(reverse('notifications'))
        response = c.post(reverse('delete-notif'), {'id':'1'})
        self.assertTrue(response.content == "{'return':True}")

        rseponse = c.post(reverse('delete-notif'), {'id':'c'})
        self.assertTrue(response.content == "{'return':False}")
