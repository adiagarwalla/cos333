from django import forms
from qurious.profiles.models import ProfileImage

class ProfileEditForm(forms.Form):
    """
    Form for processing profile info
    """
    profile_name = forms.CharField(required=False)
    profile_first = forms.CharField(required=False)
    profile_last = forms.CharField(required=False)
    user_email = forms.CharField(required=False)
    user_bio = forms.CharField(required=False)

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
