# This is a utility file to handle the basics
# of the opentok server side initialization and
# management.
import OpenTokSDK

API_KEY='44722692'
API_SECRET='527574bc6bb24ae98b168b7bf4317920e67ba45b'
opentok_object = OpenTokSDK.OpenTokSDK(API_KEY, API_SECRET)

def create_session(isEnabled):
    session_prop = {OpenTokSDK.SessionProperties.p2p_preference: isEnabled}
    session = opentok_object.create_session(None, session_prop).session_id
    return session

def generate_token(session_id):
    token = opentok_object.generate_token(session_id)
    return token
