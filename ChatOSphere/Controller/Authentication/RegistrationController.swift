//
//  RegistrationController.swift
//  ChatOSphere
//
//  Created by JATIN YADAV on 27/06/23.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: - PROPERTIES
    private let imagePicker  = UIImagePickerController()
    private var profileImage : UIImage?
    
    private let plusPhotoButton  : UIButton = {
        let button  = UIButton (type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView : UIView = {
        let image  = UIImage(systemName: "envelope")!
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passwordContainerView : UIView  = {
        let image  = UIImage(systemName: "lock")!
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        
        return view
    }()
    
    private lazy var fullNameContainerView : UIView = {
        let image  = UIImage(systemName: "envelope")!
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        
        return view
    }()
    
    private lazy var userNameContainerView : UIView  = {
        let image  = UIImage(systemName: "lock")!
        let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
        
        return view
    }()
    
    
    
    private let emailTextField : UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField : UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    private let fullNameTextField : UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let userNameTextField : UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Username")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    private let alreadyHaveAccountButton :UIButton = {
        let button = Utilities().attributedButton("Already Have An Account ? ", "Log In")
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - SELECTORS
    
    @objc func handleShowLogIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp(){
        guard var profileImage = profileImage else{
            print("Print Profile Image")
            return
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = userNameTextField.text else {return}
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
     
        AuthService.shared.registerUser(credentials: credentials) { error, ref in
            if let error = error {
                print("Error in Registering \(error.localizedDescription)")
            }
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                return
            }
            
            guard let tab = window.rootViewController as? MainTabController else { return }
            
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true,completion: nil)
        }
        
    }
    
    @objc func handleAddProfilePhoto(){
        present(imagePicker,animated: true,completion: nil)
    }
    
    //MARK: - HELPERS
    
    func configureUI(){
        
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews:[emailContainerView , passwordContainerView,fullNameContainerView,userNameContainerView ,signUpButton ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        
        stack.anchor(top: plusPhotoButton.bottomAnchor , left : view.leftAnchor , right: view.rightAnchor,paddingLeft: 32,paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left:view.leftAnchor , bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 40,paddingRight: 40)
    }
    
}

extension RegistrationController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.profileImage = profileImage
        
        dismiss(animated: true,completion: nil)
    }
}
