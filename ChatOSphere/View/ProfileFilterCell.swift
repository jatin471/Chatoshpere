//
//  ProfileFilterCell.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 30/06/23.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    
    //MARK: - PROPERTIES
    
    var option : ProfileFilterOptions! {
        didSet{
            titleLabel.text = option.description
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text  = "Test Filter"
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
