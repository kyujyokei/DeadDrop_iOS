//
//  PostViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/2.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    var statusReply:String!
    
    let manager = CLLocationManager() // This is for getting user's current location
    
    let uploadAlert = UIAlertController(title: "Uploading",
                                        message: "Please wait",
                                        preferredStyle: .alert)
    
    var newDrop = Drop(lat: 0.0, long: 0.0, message: "", date: "",userName: "", userId: 0, messageId: 0 )
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    @IBOutlet weak var postTextView: UITextView!

    @IBOutlet weak var wordCountLabel: UILabel!
    var wordCount = 280 // sets the maximum limit for inputting words
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonAction(_ sender: UIButton) {
        
        // this part generates the upload alet view
        self.present(uploadAlert, animated: true, completion:  nil)

        guard let url = URL(string:"http://localhost:443/api/message") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.object(forKey: "token") as! String,  forHTTPHeaderField: "x-auth" )
        print("POSTED")
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateTime = dateFormatter.string(from: date)
  
        let newPost = MessageForPost(message: postTextView.text, timestamp: dateTime, latitude: String(latitude), longitude: String(longitude))
        let newData = DataForPost(message: newPost)
        let newPackage = PackageForPost(data: newData)

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
            print("DATA:",data)
            print("RESPONSE:",response)
            print("STATUS CODE: ", response.statusCode)
//            let parsedResult: AnyObject?
            do{
                switch (response.statusCode) {
                case 200:
                    let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                    print("SUCCESS:\(parsedResult.success), MESSAGE:\(String(describing: parsedResult.message))")
                    if (parsedResult.success == true){
                        print("ALERT VIEW")
                        
                        performUIUpdatesOnMain {
                            self.uploadAlert.dismiss(animated: true, completion: nil)
                            // TODO: THIS PART DOESN"T WORK
                            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }

                    }
                    return
                default:
                    let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                    print("PARSED RESULT:",parsedResult)
                }


            }catch let err{
//                parsedResult = "Parse error" as AnyObject
                print("Session Error: ",err)
            }
            

        }
        
      
        
        performUIUpdatesOnMain {
//            self.uploadAlert.dismiss(animated: true, completion: nil)

//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.dismiss(animated: true, completion: nil)
//            }
            
            
        }
        
        task.resume()

    }
    
    // Get the current location of user
    // This function will be called everytime when our user changes their location
    // @params: locations : an array that stores locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent position
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }

    
    // if the text changes in text view
    // returns a bool, if false we don't want to add more characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.length + range.location > postTextView.text.count {
            return false
        }
        let newLength = postTextView.text.count + text.count - range.length

        let wordLeft = wordCount - (postTextView.text.count + text.count)
        // postTextView.text.characters.count is the accumulated word count already inputed
        // text.characters.count is the word count you just inputted (usually = 1)
        if (newLength == 0){
            self.postButton.isEnabled = false
        }else if (wordLeft > 0 ) {
            self.postButton.isEnabled = true
            self.wordCountLabel.text = String(wordCount - (newLength))
            // updates the word count label
            self.wordCountLabel.textColor = UIColor.black

        } else if (wordLeft == 0){
            self.wordCountLabel.text = "0"
            self.wordCountLabel.textColor = UIColor.red
        }
        print("\(postTextView.text.count)  \(text.count)")
        print("newLength:\(newLength)")

        return newLength <= wordCount // will stop input after reaching this limit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTextView.delegate = self //why??
        wordCountLabel.text = String(wordCount)
        
        manager.delegate = self as CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
        
        postButton.isEnabled = false
        
        postTextView.becomeFirstResponder() // pulls out the keyboard
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toTable"{
//            let Destination : MainTableViewController = segue.destination as! MainTableViewController
//            let newDrop = Drop.init(lat: latitude!, long: longitude!, message: postTextView.text)
//            DropManager.add(drop: newDrop)
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
