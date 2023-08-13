//
//  UserService.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 28/06/23.
//

import Foundation
import Firebase

typealias DataBaseCompletion = ((Error? , DatabaseReference)->Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid : String , completion : @escaping (User)->Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
        
            let user = User(dictionary: dictionary, uid: uid)
            
            completion(user)
        }
    }
    
    
    func fetchUsers(completion:@escaping([User])->Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            let user  = User(dictionary: dictionary, uid: uid)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid:String , completion : @escaping(DataBaseCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid : 1]) { err, DatabaseReference in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid :1 ], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid:String , completion : @escaping(DataBaseCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue (completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid:String , completion : @escaping(Bool)->Void){
        guard let currenctUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currenctUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats (uid:String , completion : @escaping(UserRelationStats)->Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following  = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(following: following, followers: followers)
                completion(stats)
            }
        }
    }
}
