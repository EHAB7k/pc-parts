//
//  LoginViewController.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    @IBOutlet weak var SignInLabel: UILabel!{
        didSet{
            SignInLabel.text = "Sign In".localized
        }
    }
    
    @IBOutlet weak var massgeWelcameLabel: UILabel!{
        didSet{
            massgeWelcameLabel.text = "Hi there! Nice to see you again".localized
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet{
            emailLabel.text = "Email".localized
        }
    }
    
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.text = "Password".localized
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.setTitle("Login".localized, for: .normal)
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.setTitle("Register".localized, for: .normal)
        }
    }
    
    
    
    @IBOutlet weak var passwordHideOrShow: UIButton!
       
    
    @IBOutlet weak var emailTextField: UITextField!
    var iconClick = false
    let imageIcon = UIImageView()
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.rightView = passwordHideOrShow
        passwordTextField.rightViewMode = .always


        
        

        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func changePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }
    
    
    @IBAction func hanleLogin(_ sender: Any) {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
