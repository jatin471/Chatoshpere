//
//  User.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 28/06/23.
//

import Firebase

struct User {
    let email : String
    let fullname: String
    let username : String
    let profileImageUrl : URL?
    let uid : String
    var userIsFollowed = false
    var stats:UserRelationStats?
    
    var isCurrentUser : Bool {return Auth.auth().currentUser?.uid == uid}
    
    init(dictionary: [String: AnyObject], uid: String) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let profileImageURLString = dictionary["profileImageUrl"] as? String,
           let url = URL(string: profileImageURLString) {
            self.profileImageUrl = url
        } else {
            self.profileImageUrl = nil
        }
        self.uid = uid
    }

}

struct UserRelationStats{
    var following : Int
    var followers : Int
    
}
