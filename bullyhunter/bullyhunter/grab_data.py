import tweepy
from tweepy import OAuthHandler
from tweepy import StreamListener
import json, time, sys

class SListener(StreamListener):

    def __init__(self, api = None, fprefix = 'streamer'):
        self.api = api or API()
        self.counter = 0
        self.fprefix = fprefix
        self.output  = open(fprefix + '.' 
                            + time.strftime('%Y%m%d-%H%M%S') + '.json', 'w')
        self.delout  = open('delete.txt', 'a')

    def on_data(self, data):

        if  'in_reply_to_status' in data:
            self.on_status(data)
        elif 'delete' in data:
            delete = json.loads(data)['delete']['status']
            if self.on_delete(delete['id'], delete['user_id']) is False:
                return False
        elif 'limit' in data:
            if self.on_limit(json.loads(data)['limit']['track']) is False:
                return False
        elif 'warning' in data:
            warning = json.loads(data)['warnings']
            print warning['message']
            return True

    def on_status(self, status):
        self.output.write(status + "\n")
        
        #decoded is a dictionary of the tweets
        decoded = json.loads(status)

        #put your classifier here 
        
        
        #print decoded["text"]
        
	#this is saving the tweets into a jason file
        #self.counter += 1
	#
        #if self.counter >= 20000:
        #    self.output.close()
        #    self.output = open('../streaming_data/' + self.fprefix + '.' 
        #                       + time.strftime('%Y%m%d-%H%M%S') + '.json', 'w')
        #    self.counter = 0

        return

    def on_delete(self, status_id, user_id):
        self.delout.write( str(status_id) + "\n")
        return

    def on_limit(self, track):
        sys.stderr.write(track + "\n")
        return

    def on_error(self, status_code):
        sys.stderr.write('Error: ' + str(status_code) + "\n")
        return False


    def on_timeout(self):
        sys.stderr.write("Timeout, sleeping for 60 seconds...\n")
        time.sleep(60)
        return 

#token and keys from twitter application
consumer_key = 'JqQ1lAWg90PVD9U8XoDWedCm8'
consumer_secret = 'QaUe7V9HuYQvC031MVqpUuuP2OjieI0BBDEHLpFOR221zjQ0xp'
access_token = '3299869044-UVd8CwTfnDgcGFGPro2yGXKWhArKtXRxC6iekmH'
access_secret = '3XtGQi1naI1V9wCVs2aQgEeVWr65vXDczOwGvqa3iGlEG'
 
## authentication
auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
 
api = tweepy.API(auth)

def main():
    track = ['Berkeley']
 
    listen = SListener(api, 'myprefix')
    stream = tweepy.Stream(auth, listen)

    print "Streaming started..."

    try:
        #it seems twitter does not support location and other filter, see the twitter api 
        #stream.filter(track = track, locations=[-122.75,36.8,-121.75,37.8])
	#this is the SF area
        stream.filter(locations=[-122.75,36.8,-121.75,37.8])
    except Exception,e: 
        print str(e)
        stream.disconnect()

if __name__ == '__main__':
    main()
