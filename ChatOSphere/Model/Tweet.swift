//
//  Tweet.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 29/06/23.
//

import Foundation

struct Tweet {
    let caption : String
    let tweetID : String
    var likes  : Int
    var timestamp : Date!
    let retweetCount : Int
    var user : User
    var didLiked = false
    var replyingTo : String?
    
    var isReply : Bool { return replyingTo != nil }
    
    init(user: User ,tweetID : String , dictionary  :[String : Any ]){
        self.tweetID = tweetID
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweetCount"] as? Int ?? 0
       
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
    }
}
