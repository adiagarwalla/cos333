from django.contrib.auth.models import User
from django.core.urlresolvers import reverse
from django.test.client import Client
from qurious.profiles.models import UserProfile, Skill

def login():
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
