//
//  NotificationViewModel.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 04/08/23.
//

import Foundation
import UIKit

struct NotificationViewModel {
    private let notification :Notification
    private let type : NotificationType
    private let user : User
    
    var timestamp  :String? {
        let formatter  = DateComponentsFormatter()
        formatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now ) ?? "2m"
    }
    
    var notificationMessage : String {
        switch type {
        case .follow: return " Started Following You"
        case .like: return "Liked Your Tweet"
        case .reply: return "Replied To Your Tweet"
        case .retweet: return "Retweeted Your Tweet"
        case .mention: return "Mention You In A Tweet"
        }
    }
    
    var notificationText : NSAttributedString? {
        guard let timestamp = timestamp else {return nil}
        let attributedText = NSMutableAttributedString(string: user.username , attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]))
        
        return attributedText
    }
    
    var profileImageURL : URL?{
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton : Bool {
        return type != .follow
    }
    
    var followButtonText : String {
        return user.userIsFollowed ? "Following" : "Follow"
    }
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
    
}


