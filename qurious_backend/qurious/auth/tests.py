"""
This file demonstrates writing tests using the unittest module. These will pass
when you run "manage.py test".

Replace this with more appropriate tests for your application.
"""

from django.test import TestCase
from django.test.client import Client
from django.core.urlresolvers import reverse

from django.contrib.auth.models import User
from qurious.profiles.models import UserProfile, Skill

class SimpleTest(TestCase):
    def test_basic_addition(self):
        """
        Tests that 1 + 1 always equals 2.
        """
        self.assertEqual(1 + 1, 2)

class TestRegistrationFeatures(TestCase):
    def test_login(self):
        client = Client()

        user_dummy = User(username='xxxchengexterminator', email='sam@chengdynasties.srb.gov.onion')
        user_dummy.set_password('123')
        user_dummy.save()
        user_dummy_profile = UserProfile(user=user_dummy, profile_name='cheng', user_email=user_dummy.email, user_bio ='Hello')
        user_dummy_profile.save()
        s = Skill(name='learning', desc='cheng', price=1, is_marketable=True)
        s.save()
        user_dummy_profile.skills.add(s)
        user_dummy_profile.save()

        response = client.post(reverse('login'), {'username':'xxxchengexterminator', 'password':'123'})
        self.assertTrue(response.content != '')

        response = client.post(reverse('login'), {'username':'xxxchengexterminator', 'password':'wrong'})
        self.assertTrue(response.content == '')

    def test_signup(self):
        client = Client()
        response = client.post(reverse('signup'), {'username':'cheng', 'password':'123', 'user_email':'sam@cd'})
        self.assertTrue(response.content == '{"return": "1"}')
        
        response = client.get(reverse('profile-detail') + '?id=1')
        self.assertTrue(response.content != '')

        response = client.post(reverse('signup'), {'username':'cheng', 'password':'123', 'user_email':'sam@cd'})
        self.assertTrue(response.content == '{"return": "0"}')

    def test_signup_fail(self):
        client = Client()
        
        response = client.post(reverse('signup'), {'this should fail':'fail'})

        self.assertTrue(response.content == '')

        response = client.post(reverse('signup'), {'username':'cheng', 'password':'123', 'user_email':'sam@cd'})
        self.assertTrue(response.content != '')

        response = client.post(reverse('signup'), {'username':'cheng', 'password':'123', 'user_email':'sam@cd'})
        self.assertTrue(response.content == '{"return": "0"}')
