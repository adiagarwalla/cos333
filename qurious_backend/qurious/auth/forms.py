from django import forms

class ProfileSignUpForm(forms.Form):
    """
    Form for signing up
    """
    username = forms.CharField()
    password = forms.CharField()
    user_email = forms.CharField(required=False)
    
