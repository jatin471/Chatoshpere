//
//  ProfileHeaderViewModel.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 30/06/23.
//

import UIKit

enum ProfileFilterOptions : Int ,CaseIterable{
    case tweets
    case  replies
    case likes
    
    var description : String {
        switch self {
        case .tweets : return "Tweets"
        case .replies : return "Tweets & Replies"
        case .likes : return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user : User
    
    let usernameText : String
    init(user: User) {
        self.user = user
        
        self.usernameText = "@" + user.username
        
    }
    var followersString : NSAttributedString{
        return attributedText(withValue: user.stats?.followers ?? 0, text: " followers")
    }
    
    var followingString : NSAttributedString{
        return attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }
    
    var actionButtonString : String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        if !user.userIsFollowed && !user.isCurrentUser {
            return "Follow"
        }
        if user.userIsFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    fileprivate func attributedText(withValue value : Int , text :String)->NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: "\(text)",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
}
