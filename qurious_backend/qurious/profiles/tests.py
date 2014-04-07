"""
This file demonstrates writing tests using the unittest module. These will pass
when you run "manage.py test".

Replace this with more appropriate tests for your application.
"""

import re
from django.test import TestCase
from django.test.client import Client
from django.contrib.auth import authenticate, login

from django.contrib.auth.models import User
from qurious.profiles.models import UserProfile, Skill
from django.core.urlresolvers import reverse

class SimpleTest(TestCase):
    def test_basic_addition(self):
        """
        Tests that 1 + 1 always equals 2.
        """
        self.assertEqual(1 + 1, 2)

class ProfileViewTest(TestCase):

    def test_get_profile(self):
        """
        This method tests for getting back a complete profile for a 
        given id.
        """
        client = Client()
        user_dummy = User(username='sam', email='sam@sam.com', password='123')
        user_dummy.save()
        user_dummy_profile = UserProfile(user=user_dummy, profile_name='cheng', user_email=user_dummy.email, user_bio='1234i love cheng')

        # dummmy skill needs to be created
        s = Skill(name='learning', desc='i love cheng desks', price=123445, is_marketable=True)

        user_dummy_profile.save()
        s.save()
        user_dummy_profile.skills.add(s)
        user_dummy_profile.save()

        # now that the dummy profile has been created, we need to test the item can be called back

        response = client.get(reverse('profile-detail') + '?id=1')
        self.assertTrue(response.content != '[]')

    def test_all_profiles(self):
        """
        This tests the all profiles endpoint with basic functionality
        """
        client = Client()
        self.test_get_profile()

        response = client.get(reverse('all-profile'))
        self.assertTrue(response.content != '[]')


    def test_empty_profiles(self):
        """
        Null case, test for test cases
        """
        client = Client()
        response = client.get(reverse('profile-detail') + '?id=1')
        self.assertTrue(response.content == '[]')

    def test_simple_post_profile_changes(self):
        """
        This method will test our post profile endpoint that allows you to edit a profile in the system via a post!
        """
        self.test_get_profile()
        c = Client()

        # This function assumes that every single thing is passed in that is needed by the function
        response = c.post(reverse('profile-detail'), {'user':{'username':'sam'},'profile_name':'cheng_dynasties', 'user_bio':'Hi', 'user_email':'xxx-xxxx.onion.cheng'})
        self.assertTrue(response.status_code == 200)
        self.assertTrue(bool(response.content) == True)

        # check that the individual fields were actually changed.
        cheng = User.objects.get(username='sam')
        self.assertTrue(cheng.userprofile.profile_name == 'cheng_dynasties')
        self.assertTrue(cheng.userprofile.user_bio == 'Hi')
        self.assertTrue(cheng.userprofile.user_email == 'xxx-xxxx.onion.cheng')

    def test_skill_get(self):
        """
        This method will test getting a skill
        """
        self.test_get_profile()
        c = Client()
        response = c.get(reverse('skill-view')+'?id=1')
        
        self.assertTrue(response.content != '[]')
        self.assertTrue(re.search('learning', response.content))
        
    def test_skill_null(self):
        c = Client()
        response = c.get(reverse('skill-view')+'?id=1')
        
        self.assertTrue(response.content == '[]')
