//
//  SignupViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/28.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
        if (pwdTextField.text == confirmPwdTextField.text) {
        
            guard let url = URL(string:"http://localhost:443/user/register") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print("CREATE ACCOUNT POST SENT")
        
//            let newPost = MessageForPost(message: postTextView.text, timestamp: dateTime, latitude: String(latitude), longitude: String(longitude))
//            let newData = DataForPost(message: newPost)
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
                
                guard let response = response,let data = data else {return}
                print("RESPONSE:",response)
                do{
                    //                print("NSDATA:",data as NSData)
                    //                let sendPost = try JSONDecoder().decode(PackageForPost.self, from: data)
                    //                let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //                print("PARSED RESULT:\(sendPost)")
                    //                let responseStatus = try JSONDecoder().decode(Response.self, from: response)
                    
                    
                }catch let err{
                    
                    print("Session Error: ",err)
                }
            
        }
        performUIUpdatesOnMain {
//            self.uploadAlert.dismiss(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        
        task.resume()
            }
        
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
