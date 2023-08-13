//
//  CaptionTextView.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 28/06/23.
//

import UIKit

class CaptionTextView: UITextView {

    //MARK: - PROPERTIES
    
    let placeholderlabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's Happeneing"
        return label
    }()
    
    //MARK: - LIFECYCLE
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(placeholderlabel)
        placeholderlabel.anchor(top:topAnchor,left:leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SELECTOR
    
    @objc func handleTextInputChange() {
        placeholderlabel.isHidden = !text.isEmpty
        textColor = .black
    }
    
}
