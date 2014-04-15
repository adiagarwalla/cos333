from django import forms

class CreateSessionForm(forms.Form):
    """
    this is the form for handling session creation
    """
    teacher = forms.IntegerField()
    time = forms.IntegerField()
