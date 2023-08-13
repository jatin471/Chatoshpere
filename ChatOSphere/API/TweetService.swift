//
//  TweetService.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 28/06/23.
//

import Firebase

struct TweetService {
    static let shared  = TweetService()
    
    func uploadTweet(caption : String ,type:UploadTweetConfiguration , completion : @escaping(Error?,DatabaseReference)->Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values = ["uid" : uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970) ,
                      "likes":0,
                      "retweets":0,
                      "caption" : caption] as [String :Any]
        
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { error , ref in
                guard let tweetId = ref.key else {return}
                REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values) { err, ref in
                guard let replyKey = ref.key else {return}
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID : replyKey] , withCompletionBlock: completion)
            }
        }
        
        let ref = REF_TWEETS.childByAutoId()
        
        ref.updateChildValues(values) { error , ref in
            guard let tweetId = ref.key else {return}
            REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
        }
    }
    
    
    
    func fetchTweets(completion : @escaping([Tweet])->Void){
        var tweets  = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot  in
            guard let dictionary  = snapshot.value as? [String:Any ] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetId  = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user, tweetID: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user:User , completion :@escaping([Tweet])->Void){
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweets(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(withTweetID tweetID: String , completion: @escaping(Tweet) -> Void){
        
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary  = snapshot.value as? [String:Any ] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
        
    }
    
    func fetchReplies(forUser user: User , completion: @escaping([Tweet])->Void){
        var replies = [Tweet]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else {return}
            
            REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary  = snapshot.value as? [String:Any ] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    
    func fetchReplies(forTweet tweet:Tweet ,completion :@escaping([Tweet])->Void){
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot  in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            let tweetId  = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user:user, tweetID: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchLikes(forUser user:User , completion : @escaping([Tweet])->Void){
        var tweets = [Tweet]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            self.fetchTweets(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLiked = true
                
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet : Tweet , completion : @escaping(DataBaseCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let likes = tweet.didLiked ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLiked {
            //unlike tweet
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
            
        }else{
            //like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID : 1]) { err, ref in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid : 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet (_ tweet : Tweet , completion : @escaping(Bool)->Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_LIKES  .child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
        
    }
}
