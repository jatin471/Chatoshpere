//
//  TweetViewModel.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 29/06/23.
//

import UIKit

struct TweetViewModel {
    
    //MARK: - PROPERITES
    
    let tweet : Tweet
    let user : User
    
    
    var profileImageUrl : URL?{
        return tweet.user.profileImageUrl
    }
    
    var timestamp  :String {
        let formatter  = DateComponentsFormatter()
        formatter.allowedUnits = [.second , .minute , .hour , .day , .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now ) ?? "2m"
    }
    
    var usernameText : String {
        return "@\(user.username)"
    }
    
    var headerTimestamp : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetsAttributedString : NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: " Retweets")
    }
    
    var likesAttributedString : NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: " Likes")
    }
    
    var userInfoText : NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname , attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)",attributes: [.font: UIFont.systemFont(ofSize: 14) , .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: "・ \(timestamp)",attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        
        return title
    }
    
    var likeButtonTintColor : UIColor {
        return tweet.didLiked ? .red : .lightGray
    }
    
    var likeButtonImage : UIImage {
        let imageName = tweet.didLiked ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel : Bool {
        return !tweet.isReply
    }
    
    var replyText : String? {
        guard let replyingToUsername = tweet.replyingTo else {return nil}
        return "-> Replying to @\(replyingToUsername)"
    }
    
    //MARK: - LIFECYCLE
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(withValue value : Int , text :String)->NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: "\(text)",attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
    
    //MARK: - HELPERS
    
    func size(forWidth width : CGFloat)->CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
