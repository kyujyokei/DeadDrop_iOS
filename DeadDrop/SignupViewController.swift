//
//  SignupViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/28.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var errorTextField: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
        if (pwdTextField.text == confirmPwdTextField.text) {
        
            guard let url = URL(string:"https://deaddrop.live/user/register") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print("CREATE ACCOUNT POST SENT")
        
            let newPackage = User(username: usernameTextField.text!, password: pwdTextField.text!)
        
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
                        let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                        print("SUCCESS:\(parsedResult.success), MESSAGE:\(parsedResult.message)")
                        if parsedResult.success == false {
                            performUIUpdatesOnMain {
                                self.errorTextField.isHidden = false
                                self.errorTextField.text = parsedResult.message
                                self.errorTextField.textColor = UIColor.red
                            }
                        } else {
                            performUIUpdatesOnMain {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
