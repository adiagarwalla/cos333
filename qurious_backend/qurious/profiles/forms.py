from django import forms
from qurious.profiles.models import ProfileImage

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
    price = forms.IntegerField(required=False)
    name = forms.CharField()
    marketable = forms.CharField()
    desc = forms.CharField(required=False)
    skill_id = forms.IntegerField()

class UploadFileForm(forms.ModelForm):

    class Meta:
        model = ProfileImage
