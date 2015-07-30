package bullyhunter;

import org.apache.spark.SparkConf;
import org.apache.spark.streaming.*;
import org.apache.spark.streaming.api.java.JavaReceiverInputDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import org.apache.spark.streaming.twitter.TwitterUtils;

import twitter4j.Status;

public class TweetReader {
    public static void main(String[] args) {
        String consumerKey = "JqQ1lAWg90PVD9U8XoDWedCm8";
        String consumerSecret = "QaUe7V9HuYQvC031MVqpUuuP2OjieI0BBDEHLpFOR221zjQ0xp";
        String accessToken = "3299869044-UVd8CwTfnDgcGFGPro2yGXKWhArKtXRxC6iekmH";
        String accessTokenSecret = "3XtGQi1naI1V9wCVs2aQgEeVWr65vXDczOwGvqa3iGlEG";
        
        System.setProperty("twitter4j.oauth.consumerKey", consumerKey);
        System.setProperty("twitter4j.oauth.consumerSecret", consumerSecret);
        System.setProperty("twitter4j.oauth.accessToken", accessToken);
        System.setProperty("twitter4j.oauth.accessTokenSecret", accessTokenSecret);
        
        String [] filters = {"locations=[-122.75,36.8,-121.75,37.8]"};
        SparkConf sparkConf = new SparkConf().setAppName("bullyhunter");
        System.out.println("Started bullyhunter...");
        JavaStreamingContext sc = new JavaStreamingContext(sparkConf, Durations.seconds(2));
        JavaReceiverInputDStream<Status> stream = TwitterUtils.createStream(sc, filters);
        
        stream.print();        
        
    }
}
