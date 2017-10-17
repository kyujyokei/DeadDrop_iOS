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
    
    let manager = CLLocationManager() // This is for getting user's current location
    
    //var currentLocation:CLLocation?
    var newDrop = Drop.init(lat: 0.0, long: 0.0, message: "")
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    @IBOutlet weak var postTextView: UITextView!

    @IBOutlet weak var wordCountLabel: UILabel!
    var wordCount = 20 // sets the maximum limit for inputting words
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func postButtonAction(_ sender: UIButton) {
        
//        newDrop.latitude = latitude!
//        newDrop.longtitude = longitude!
//        newDrop.message = postTextView.text
        guard let url = URL(string:"localhost:3000/api/message") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("POSTED")

        let newMessage = Message(UUID: "123", message: "Hi", timestamp: "time", latitude: 2.2, longitude: 2.2)
        let newPost = Data(message: newMessage)
        // TODO: fix this
        // Do we have to generate the UUID?

        do {
            let jsonBody = try JSONEncoder().encode(newPost)
            request.httpBody = jsonBody
        } catch {}

        let session = URLSession.shared
        let task = session.dataTask(with: request){ (data,response,err) in
            guard let data = data else {return}
            do{
                let sendPost = try JSONDecoder().decode(Data.self, from: data)
                print("sendPost:\(sendPost)")
            }catch{}
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
        if range.length + range.location > postTextView.text.characters.count {
            return false
        }
        let newLength = postTextView.text.characters.count + text.characters.count - range.length
        
        let wordLeft = wordCount - (postTextView.text.characters.count + text.characters.count)
        // postTextView.text.characters.count is the accumulated word count already inputed
        // text.characters.count is the word count you just inputted (usually = 1)
        if (postTextView.text.characters.count == 0){
            self.postButton.isEnabled = false
        } else if (wordLeft > 0 ) {
            
            self.postButton.isEnabled = true
            self.wordCountLabel.text = String(wordCount - (postTextView.text.characters.count + text.characters.count))
            // updates the word count label
            self.wordCountLabel.textColor = UIColor.black
            
        } else if (wordLeft == 0){
            self.wordCountLabel.text = "0"
            self.wordCountLabel.textColor = UIColor.red
        }
        //print("\(postTextView.text.characters.count)  \(text.characters.count)")
        
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
