from twilio.rest import TwilioRestClient

# Find these values at https://twilio.com/user/account
account_sid = "ACXXXXXXXXXXXXXXXXX"
auth_token = "YYYYYYYYYYYYYYYYYY"
client = TwilioRestClient(account_sid, auth_token)

def send_sms(toNum,fromNum,message):
	message = client.messages.create(to="+12316851234", from_="+15555555555", body="Hello there!")