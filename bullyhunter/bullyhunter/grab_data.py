import tweepy
from tweepy import OAuthHandler
from tweepy import StreamListener
import json, time, sys
import subprocess
import sqlite3

class tweets:
	def __init__(self, tweetID, uid, timestamp, offset, city, state, geo, msg):
		self.tweetID = tweetID
		self.timestamp = timestamp
		self.offset = offset
		self.city = city
		self.state = state
		self.geo = geo
		self.msg = msg
		self.uid = uid

def outputDB(tweet):
	
	conn = sqlite3.connect('tweets.db')
 
	c = conn.cursor()
	
	#c.execute('''DROP TABLE tweets''')
	
	
	c.execute('''
			  CREATE TABLE IF NOT EXISTS tweets
			  (tweetID varchar(250) PRIMARY KEY, uid varchar(250), timestamp varchar(250), 
			  offset varchar(250), city varchar(250), state varchar(250), 
			   geo  varchar(250), msg varchar(250))
			  ''')
	
	id =tweet.tweetID
	timestamp = tweet.timestamp
	offset = tweet.offset
	city = tweet.city
	state = tweet.state
	geo = tweet.geo
	msg = tweet.msg
	uid = tweet.uid
	
	c.execute("INSERT INTO tweets (tweetID, uid, timestamp, offset, city, state, geo, msg) VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')" %(id, uid, timestamp, offset, city, state, geo, msg))
	conn.commit()
	conn.close()

def Enrichment(tweet):
  enrichment_words = ["ignored", "pushed", "bullie", "rumors", "locker","spread", "shoved", "rumor", "teased", "kicked", "crying","bullied", "bully", "bullyed", "bullying", "bullyer", "bulling"]
  cur_msg = tweet.msg.lower()
  passed = False
  for word in enrichment_words:
    if word in cur_msg:
      passed = True
      break
  if passed and ("bull" in cur_msg) and (not "RT" in cur_msg):
    return tweet
  else:
    return None

class SListener(StreamListener):

    def __init__(self, api = None, fprefix = 'streamer'):
        self.api = api or API()
        self.counter = 0
        self.fprefix = fprefix
        #self.output  = open(fprefix + '.' 
        #                    + time.strftime('%Y%m%d-%H%M%S') + '.json', 'w')
        #self.delout  = open('delete.txt', 'a')

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
            print(warning['message'])
            return True

    def on_status(self, status):
        #self.output.write(status + "\n")
        decoded = json.loads(status)
        try:
            geo = decoded["geo"]["coordinates"]
        except:
            geo = None
        try:
            timestamp = decoded["timestamp_ms"]
            offset = decoded["user"]["utc_offset"]
            tweetID = decoded["id"]
            msg = decoded["text"]
            uid = decoded["user"]["id"]
            [city, state] = decoded["place"]["full_name"].split(',')
        except:
            return
    
        tweet = tweets(tweetID, uid, timestamp, offset, city, state, geo, msg)
        survived_tweet = Enrichment(tweet)
        if survived_tweet:
          proc = subprocess.Popen(['java', '-jar', 'Classification.jar'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, )
          stdout_value = proc.communicate(survived_tweet.msg)[0]
          
          if stdout_value > 0:
            print('{0}, {1}, {2}, {3}'.format(survived_tweet.city, survived_tweet.state, survived_tweet.geo, survived_tweet.msg))
            outputDB(survived_tweet)
	        
        #self.counter += 1

        #if self.counter >= 20000:
        #    self.output.close()
        #    self.output = open('../streaming_data/' + self.fprefix + '.' 
        #                       + time.strftime('%Y%m%d-%H%M%S') + '.json', 'w')
        #    self.counter = 0

        return

    def on_delete(self, status_id, user_id):
        #self.delout.write( str(status_id) + "\n")
        pass
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

    print("Streaming started...")

    try: 
        #stream.filter(track = track, locations=[-122.75,36.8,-121.75,37.8])
        stream.filter(locations=[-122.75,33,-114.5,42])
        #print stream
    except Exception as e: 
        print(str(e))
        stream.disconnect()

if __name__ == '__main__':
    main()
