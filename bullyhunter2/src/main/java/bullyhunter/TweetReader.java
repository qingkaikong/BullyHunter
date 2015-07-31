package bullyhunter;

import org.apache.spark.SparkConf;
import org.apache.spark.streaming.*;
import org.apache.spark.streaming.api.java.JavaDStream;
import org.apache.spark.streaming.api.java.JavaReceiverInputDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import org.apache.spark.streaming.twitter.TwitterUtils;
import org.apache.spark.api.java.function.Function;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

import twitter4j.Status;
import bullyhunter.Enrichment;
import bullyhunter.Classification;
//import bullyhunter.TweetRecord;

public class TweetReader {
    private static final String DELIMITER = ",";
    private static final String[] keywords = { "ignored", "pushed", "rumors", "locker",
        "spread", "shoved", "rumor", "teased", "kicked", "crying",
        "bullied", "bully", "bullyed", "bullying", "bullyer", "bulling" };

    public static void main(String[] args) {
        Logger logger = Logger.getRootLogger();
        logger.setLevel(Level.OFF);
        
        String consumerKey = "JqQ1lAWg90PVD9U8XoDWedCm8";
        String consumerSecret = "QaUe7V9HuYQvC031MVqpUuuP2OjieI0BBDEHLpFOR221zjQ0xp";
        String accessToken = "3299869044-UVd8CwTfnDgcGFGPro2yGXKWhArKtXRxC6iekmH";
        String accessTokenSecret = "3XtGQi1naI1V9wCVs2aQgEeVWr65vXDczOwGvqa3iGlEG";

        System.setProperty("twitter4j.oauth.consumerKey", consumerKey);
        System.setProperty("twitter4j.oauth.consumerSecret", consumerSecret);
        System.setProperty("twitter4j.oauth.accessToken", accessToken);
        System.setProperty("twitter4j.oauth.accessTokenSecret",
                accessTokenSecret);

        String [] filters = {"bulling", "bullied", "bulling", "bullyed", "bully", "teased"};

        SparkConf sparkConf = new SparkConf().setAppName("bullyhunter");
        System.out.println("Started bullyhunter...");
        JavaStreamingContext sc = new JavaStreamingContext(sparkConf,
                Durations.seconds(2));
        JavaReceiverInputDStream<Status> stream = TwitterUtils.createStream(sc, filters);

        JavaDStream<String> text = stream
                .map(new Function<Status, String>() {
                    public String call(Status status) {
//                        String msg = status.getText();
//                        String filtered_msg = Enrichment.filter(msg);
//                        if (filtered_msg == null) {
//                            return null;
//                        }
//                        TweetRecord tr = new TweetRecord();
//                        tr.setMsg(filtered_msg);
//                        //tr.setGeo(status.getGeoLocation().getLatitude());
//                        String fullName = status.getPlace().getFullName();
//                        if (fullName == null)
//                            return null;
//                        String[] fields = fullName.spilt(DELIMITER);
//                        tr.setCity(fullName.split());
                        String msg = status.getText();
                        double ind = Classification.classifyTweet(msg);
                        if (ind > 0) {
                            return status.getText();
                        } else {
                            return null;
                        }
                    }
                });

//        text = text.filter(new Function<String, Boolean>() {
//            public Boolean call(String msg) {
//                boolean containKeyword = false;
//                String lowerCase = msg.toLowerCase();
//                for (String k : keywords)
//                    if (lowerCase.contains(k)) {
//                        containKeyword = true;
//                        break;
//                    }
//                if (containKeyword == true && lowerCase.contains("bull")
//                        && !lowerCase.contains("RT")) {
//                    return true;
//                }
//                return false;
//            }
//            
//        });
        text = text.filter(new Function<String, Boolean>() {
            public Boolean call(String msg) {
                return (msg == null) ? false : true;
            }
        });
        
        text.print();
        sc.start();
        sc.awaitTermination();
    }
}
