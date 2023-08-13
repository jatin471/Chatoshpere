//
//  UserCell.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 01/07/23.
//

import UIKit

class UserCell : UITableViewCell {
    //MARK: - PROPERTIES

    var user : User?{
        didSet{
            configure()
     
        }
    }
 
    
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .twitterBlue
       
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Username"
        return label
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Fullname"
        return label
    }()
    
    //MARK: - LIFECYCLE
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self , leftAnchor: leftAnchor , paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel , fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView , leftAnchor: profileImageView.rightAnchor , paddingLeft: 12)
        
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPERS
    
    func configure(){
        guard let user = user else {return}
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        usernameLabel.text = user.username
        fullnameLabel.text  = user.fullname
        
    }
    
   
    
}
