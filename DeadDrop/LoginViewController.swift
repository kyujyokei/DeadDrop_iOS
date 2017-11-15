//
//  LoginViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/28.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorTextField: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
  
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if ( usernameTextField.text != "" && passwordTextField.text != ""){
            guard let url = URL(string:"https://deaddrop.live/user/login") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print("CREATE ACCOUNT POST SENT")
            
            let newPackage = User(username: usernameTextField.text!, password: passwordTextField.text!)
            
            do {
                let jsonBody = try JSONEncoder().encode(newPackage)
                request.httpBody = jsonBody
                print("jsonBody:",jsonBody)
                let jsonBodyString = String(data: jsonBody, encoding: .utf8)
                print("JSON String : ", jsonBodyString!)
            } catch let err  {
                print("jsonBody Error: ",err)
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: request){ (data,response,err) in
                
                guard let response = response as? HTTPURLResponse,let data = data else {return}
                print("RESPONSE:",response)
                do{
                    switch (response.statusCode) {
                    case 200:
                        let parsedResult = try JSONDecoder().decode(TokenResponse.self, from: data)
                        print("SUCCESS:\(parsedResult.success), MESSAGE:\(parsedResult.message ?? "OK")")
                        UserDefaults.standard.set(parsedResult.token, forKey: "token")
                        print("TOKEN:",UserDefaults.standard.object(forKey: "token"))
                        if parsedResult.success == false {
                            // if login fails
                            performUIUpdatesOnMain {
                                self.errorTextField.isHidden = false
                                self.errorTextField.text = parsedResult.message
                            }
                        } else {
                            // if login succeed
                            performUIUpdatesOnMain {
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.performSegue(withIdentifier: "showTable", sender: nil)
                                }
                            }
                            
                        }
                    default:
                        let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                        print("PARSED RESULT:",parsedResult)
                    }
                    
                }catch let err{
                    
                    print("Session Error: ",err)
                }
                
            }
            
            
            task.resume()
        }
        
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
        self.view.endEditing(true)
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
