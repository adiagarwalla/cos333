from django import forms

class ProfileEditForm(forms.Form):
    """
    Form for processing profile info
    """
    profile_name = forms.CharField()
    profile_first = forms.CharField()
    profile_last = forms.CharField()
    user_email = forms.CharField()
    user_bio = forms.CharField()

class SkillEditForm(forms.Form):
    """
    Form for editing skills
    """
    price = forms.IntegerField()
    name = forms.CharField()
    marketable = forms.CharField()
    desc = forms.CharField()
    skill_id = forms.IntegerField()
