//
//  Notification.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 06/07/23.
//

import Foundation

enum NotificationType : Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID : String?
    let timestamp : Date!
    var user : User
    var tweet : Tweet?
    var type : NotificationType!
    
    init(user:User , dictionary : [String : AnyObject]) {
        
        self.user = user
        
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double
        {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        else
        {
            self.timestamp = Date()
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
