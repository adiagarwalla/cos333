# This is a utility file to handle the basics
# of the opentok server side initialization and
# management.
import OpenTokSDK

API_KEY='44754902'
API_SECRET='71f77d3e3af14ab58036a38c93ee6b923984b677'
opentok_object = OpenTokSDK.OpenTokSDK(API_KEY, API_SECRET)

def create_session(isEnabled):
    session_prop = {OpenTokSDK.SessionProperties.p2p_preference: isEnabled}
    session = opentok_object.create_session(None, session_prop).session_id
    return session

def generate_token(session_id):
    token = opentok_object.generate_token(session_id)
    return token
