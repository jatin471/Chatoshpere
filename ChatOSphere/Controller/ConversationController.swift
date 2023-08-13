//
//  ConversationController.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 27/06/23.
//

import UIKit

class ConversationController : UIViewController {
    
    //MARK: - PROPERTIES

    
    //MARK : - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    //MARK : - HELPERS
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
