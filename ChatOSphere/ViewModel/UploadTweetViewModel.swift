//
//  UploadTweetViewModel.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 02/07/23.
//

import UIKit


enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle : String
    let placeholderText : String
    let shouldShowReplyLabel : Bool
    var replyText : String?
    
    init(config : UploadTweetConfiguration){
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's Happening?"
            shouldShowReplyLabel = false
        case.reply(let tweet) :
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
