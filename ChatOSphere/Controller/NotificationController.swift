//
//  NotificationController.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 27/06/23.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController : UITableViewController {
    
    //MARK: - PROPERTIES
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    //MARK: - API
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkIfUserIsFollowed(notofication: notifications)
        }
    }
    
    func checkIfUserIsFollowed(notofication : [Notification]) {
        for (index , notification) in notifications.enumerated() {
            if case .follow = notification.type {
                let user = notification.user
                
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.userIsFollowed = isFollowed
                }
            }
        }
    }
    
    
    //MARK: - HELPERS
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

//MARK: - UITABLEVIEWDATASOURCE

extension NotificationController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

//MARK: - UITABLEVIEWDELEGATE

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else {return}
        
        TweetService.shared.fetchTweets(withTweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationController : NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        
        guard let user = cell.notification?.user else {return}
        
        if user.userIsFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                cell.notification?.user.userIsFollowed = false
            }
        }else{
            UserService.shared.followUser(uid: user.uid) { err, ref in
                cell.notification?.user.userIsFollowed = true
            }
        }
        
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
