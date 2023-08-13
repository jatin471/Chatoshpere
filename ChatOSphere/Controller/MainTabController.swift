//
//  MainTabController.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 27/06/23.
//

import UIKit
import Firebase



class MainTabController: UITabBarController {
    
    //MARK: - PROPERTIES
    
    var user :User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed  = nav.viewControllers.first as? FeedController else {return}
            feed.user = user
        }
    }
    
    let actionButton:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
//                logUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) {user in
            self.user = user
            
        }
        
    }
    
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }else{
            configureViewController()
            configureUI()
            fetchUser()
        }
    }
    
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Failed To Log Out \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    //MARK: - SELECTORS
    @objc func actionButtonTapped() {
        guard let user = user else {return}
        let controller  = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
    //MARK: - HELPERS
    
    func configureUI(){
        view.addSubview(actionButton)
        
        
        
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
    }
    
    func configureViewController(){
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(systemName: "house")!, rootViewController: feed)
        
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "magnifyingglass")!, rootViewController: explore)
        
        
        let notifications = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "heart")!, rootViewController: notifications)
        
        
        let conversations = ConversationController()
        let nav4 = templateNavigationController(image: UIImage(systemName: "envelope")!, rootViewController: conversations)
        
        
        tabBar.tintColor = .systemBlue
        viewControllers = [ nav1 , nav2 ,nav3 , nav4 ]
    }
    
    func templateNavigationController(image: UIImage ,rootViewController : UIViewController)->UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}

