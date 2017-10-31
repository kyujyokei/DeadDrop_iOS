//
//  LoginViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/28.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
  
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
    }
    
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        

        let background = UIImage(named: "bg.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        loginBtn.backgroundColor = .clear
        loginBtn.layer.cornerRadius = loginBtn.bounds.size.height/2
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.white.cgColor
        
        signupBtn.backgroundColor = .clear
        signupBtn.layer.cornerRadius = loginBtn.bounds.size.height/2
        signupBtn.layer.borderWidth = 1
        signupBtn.layer.borderColor = UIColor.white.cgColor
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        // dismiss keyboard with "return" key
        self.view.endEditing()
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
