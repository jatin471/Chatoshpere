//
//  TweetHeader.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 01/07/23.
//

import UIKit

protocol TweetHeaderDelegate : AnyObject {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
        
    //MARK: - PROPERTIES
    
    var tweet : Tweet? {
        didSet{
            configure()
        }
    }
    
    weak var delegate : TweetHeaderDelegate?
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Peter Parker"
        return label
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "SpiderMan"
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "SpiderMan SpiderMan SpiderMan SpiderMan SpiderMan Hanuman"
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "12/34 "
        return label
    }()
    
    private lazy var optionsButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "chevron.down")!, for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let replyLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let retweetsLabel = UILabel()
    
    private let likesLabel = UILabel()
    
    private lazy var statsView : UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top:view.topAnchor , left: view.leftAnchor , right: view.rightAnchor , paddingLeft: 8 , height: 1.8)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel , likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor , paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(left: view.leftAnchor , bottom: view.bottomAnchor , right: view.rightAnchor , paddingLeft: 8 , height: 1.0)
        
        
        return view
    }()
    
    private lazy var commentButton : UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsButton : UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likesButton : UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - LIFECYCLE
    
    override init(frame : CGRect){
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel , usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,labelStack])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [replyLabel , imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top:topAnchor , left: leftAnchor ,paddingTop: 16 ,paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top : stack.bottomAnchor , left: leftAnchor , right: rightAnchor , paddingTop: 12 , paddingLeft: 16 , paddingRight: 16)
        
        
        addSubview(dateLabel)
        dateLabel.anchor(top:captionLabel.bottomAnchor ,left: leftAnchor , paddingTop: 20 ,paddingLeft: 16 )
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor , paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top : dateLabel.bottomAnchor ,left: leftAnchor , right: rightAnchor , paddingTop: 12 ,height: 40)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton , retweetsButton , likesButton , shareButton])
        
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor ,paddingBottom: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SELECTORS
    
    @objc func handleProfileImageTapped () {
        
    }
    
    @objc func showActionSheet () {
        delegate?.showActionSheet()
    }
    
    
    @objc func handleCommentTapped () {
        
    }
    
    @objc func handleRetweetTapped () {
        
    }
    
    
    @objc func handleLikeTapped () {
        
    }
    
    @objc func handleShareTapped () {
        
    }
    
    
    
    
        //MARK: - HELPERS
                                                                                                                                                                                                                
    func configure() {
        guard let tweet  = tweet else {return}
        
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        likesButton.setImage(viewModel.likeButtonImage, for: .normal)
        likesButton.tintColor = viewModel.likeButtonTintColor
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    func createButton(withImageName imageName : String)-> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    
}
