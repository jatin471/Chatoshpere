//
//  FeedController.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 27/06/23.
//

import UIKit
import SDWebImage

private let reuseIdentifier  = "TweetCell"

class FeedController : UICollectionViewController {
    
    //MARK: - PROPERTIES
    
    var user :User? {
        didSet{
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet](){
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweet()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchTweet() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
            
            for(index,tweet) in tweets.enumerated() {
                TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                    guard didLike == true else {return}
                    
                    self.tweets[index].didLiked = true
                    
                }
            }
        }
    }
    
    
    //MARK: - HELPERS
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        
        guard let user = user else {return}
        
        let profileImageView = UIImageView()
        
        profileImageView.setDimensions(width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
}

//MARK: - UICOLLECTIONVIEWDELEGATE/DATASOURCE

extension  FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath ) as! TweetCell
        
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICOLLECTIONVIEWDELEGATEFLOWLAYOUT
 
extension FeedController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth : view.frame.width ).height
        
        return CGSize(width: view.frame.width, height: height + 80)
    }
}


//MARK: - TWEETCELLDELEGATE
extension FeedController : TweetCellDelegate {
    
    func handleLikeTapped(_ cell: TweetCell) {
        
        guard var tweet = cell.tweet else{return}
        
        TweetService.shared.likeTweet(tweet: tweet) { err, ref in
            cell.tweet?.didLiked.toggle()
            let likes = tweet.didLiked ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
        
            guard !tweet.didLiked else {return}
            NotificationService.shared.uploadNotification(type: .like , tweet: tweet)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true , completion: nil)
    }
                                                                                                                                                                                                                
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user:user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
