# This is a utils file so that you can easily recreate the user_profile objects
from django.contrib.auth.models import User
from qurious.profiles.models import UserProfile, Skill

def install_test_user():

    user_dummy = User(username='sam', email='sam@sam.com', password='123')
    user_dummy.save()
    user_dummy_profile = UserProfile(user=user_dummy, profile_name='cheng', user_email=user_dummy.email, user_bio='1234i love cheng')

    # dummmy skill needs to be created
    s = Skill(name='learning', desc='i love cheng desks', price=123445, is_marketable=True)

    user_dummy_profile.save()
    s.save()
    user_dummy_profile.skills.add(s)
    user_dummy_profile.save()
