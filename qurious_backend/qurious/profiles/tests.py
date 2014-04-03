"""
This file demonstrates writing tests using the unittest module. These will pass
when you run "manage.py test".

Replace this with more appropriate tests for your application.
"""

from django.test import TestCase
from django.test.client import Client

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

