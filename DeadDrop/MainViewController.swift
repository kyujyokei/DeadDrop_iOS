//
//  MainViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/27.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, SettingsLauncherDelegate, MainTableViewCellDelegate {

    // MARK: - Properites
    
    let manager = CLLocationManager() // This is for getting user's current location
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var currLocation:CLLocation?
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        let now = Date()
        print("DATE:",now)
        // now is the recent time
        
        let tokenDate = UserDefaults.standard.object(forKey: "tokenDate") as! NSDate
        print("tokenDATE:\(tokenDate)")
        // tokenDate is the timestamp when loggin in
        
        let calendar = Calendar(identifier: .gregorian)
        let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour, .minute])
        var duration = calendar.dateComponents(unitFlags, from: tokenDate as Date, to: now)


        print("DURATION:",duration.hour!)
        
        if (duration.hour! < 24){
            // if the token reached 24 hours, 
            performSegue(withIdentifier: "toPost", sender: self)
        } else {
            let alertController = UIAlertController(title: "Session Expired", message: "Your session has expired! Please log in again", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            // TODO: Make this go to root controller
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let blackView = UIView()
    let settingsLauncher = SettingsLauncher()
    
    @IBAction func refreshBtnAction(_ sender: UIButton) {
        settingsLauncher.showSettings()
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.blackView.alpha = 0
            // dismisses blackView
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent location
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        currLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        
        // refreshes everytime user moves to a new location
        getData(latitude: latitude!, longitude: longitude!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self as CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        
        tableView.reloadData()
        print("RELOAD DATA")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        // removes the empty table view ceels

        addBtn.layer.cornerRadius = 0.5 * addBtn.bounds.size.width
        addBtn.clipsToBounds = true
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        settingsLauncher.delegate = self
        
        //https://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
//        tableView.refreshControl = refreshControl
    }
    
    // MARK: - Settings Menu
    
    func didSelect(setting: EnumSetting) {
        defer {
            settingsLauncher.handleDismiss()
        }
        print("Did select setting \(setting)")
        
        switch (setting) {
        case .settings:
            performSegue(withIdentifier: "toRange", sender: nil)
            print("Found Settings")
        case .account:
            performSegue(withIdentifier: "toUserMessage", sender: nil)
            print("Found account")
        case .logout:
//            self.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "logout", sender: nil)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            print("logging out")
        case .cancel:
            print("Cancel")
        }
    }
    
    
    func doSomething(refreshControl: UIRefreshControl) {
        
        getData(latitude: latitude!, longitude: longitude!)
        tableView.reloadData()
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DropManager.drops.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        
        
        let i = DropManager.drops[indexPath.row]
        
        // this part allows messages to be multiple lines in label
        cell.messageLabel.lineBreakMode = .byWordWrapping
        cell.messageLabel.numberOfLines = 0
        
        cell.delegate = self
        //cell.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.dislikeButton.tag = indexPath.row
        
        cell.usernameLabel.text = i.userName
        cell.timeLabel.text = i.date
        
        cell.likeLabel.text = String(describing: i.likeCount!)
        cell.dislikeLabel.text = String(describing: i.dislikeCount!)
        
        let messageLocation = CLLocation(latitude: i.latitude, longitude: i.longtitude)
//        print("i LAT:\(i.latitude), i LONG:\(i.longtitude)")
//        print("\(latitude), \(longitude)")
        let distance = currLocation?.distance(from: messageLocation)
        
        cell.messageLabel.text = "\(String(describing: i.message!))"
        
        if let distance = distance {
            // TODO: distance will be nil after logout & login
            cell.distanceLabel.text = "\(Int(distance))m"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(DropManager.drops[indexPath.row].messageId!)
    }
    
    func didTapLike(_ tag:Int) {
        print("TAG:",tag)
        print("DROP ID:",DropManager.drops[tag].messageId!)
        
        guard let url = URL(string:"https://deaddrop.live/api/message/like") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.object(forKey: "token") as! String,  forHTTPHeaderField: "x-auth" )
        print("POSTED")
        
        
        let newLike = MessageForLike(message_id: DropManager.drops[tag].messageId!)
        
        do {
            let jsonBody = try JSONEncoder().encode(newLike)
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
                        
                        performUIUpdatesOnMain {

                            self.tableView.reloadData()
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

            self.getData(latitude: self.latitude!, longitude: self.longitude!)
            self.tableView.reloadData()
        }
        
        task.resume()
        
    }
    
    func didTapDislike(_ tag:Int) {
        print("TAG:",tag)
        print("DROP ID:",DropManager.drops[tag].messageId!)
        
        guard let url = URL(string:"https://deaddrop.live/api/message/dislike") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.object(forKey: "token") as! String,  forHTTPHeaderField: "x-auth" )
        print("POSTED")
        
        
        let newLike = MessageForLike(message_id: DropManager.drops[tag].messageId!)
        
        do {
            let jsonBody = try JSONEncoder().encode(newLike)
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
                        
                        performUIUpdatesOnMain {
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                    return
                default:
                    let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                    print("PARSED RESULT:",parsedResult)
                }
                
                
            }catch let err{
                // parsedResult = "Parse error" as AnyObject
                print("Session Error: ",err)
            }
            
            
        }
        performUIUpdatesOnMain {
            
            self.getData(latitude: self.latitude!, longitude: self.longitude!)
            self.tableView.reloadData()
        }
        
        task.resume()
    }
    public func convertStringToDate (dateString:String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print("DATE STRING\(dateString)")
        
        let date:Date = dateFormatter.date(from: dateString)!
        return date
        
    }
    
    public func getData(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        
        print("get")
        guard let url = URL(string: "https://deaddrop.live/api/message?latitude=\(latitude)&longitude=\(longitude)&range=\(UserDefaults.standard.integer(forKey: "range"))") else { return }
        
        print(url)
        
        print("latitude:",String(describing: latitude)," ,longitude:",String(describing: longitude))
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, err) in
            guard let data = data, let response = response as? HTTPURLResponse else { return }
            
            do {
                    switch (response.statusCode) {
                    case 200:
                        let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                        print("SUCCESS:\(parsedResult.success), MESSAGE:\(String(describing: parsedResult.message))")
                        if (parsedResult.success == true){
                            
                            let package = try JSONDecoder().decode(Package.self, from: data)
                            
                            let messages = package.data.messages
                            
                            DropManager.clearAll() // clean Drops to prevent multiple loads
                            
                            for i in messages {
                                let new = Drop.init(lat: CLLocationDegrees(i.latitude)!, long: CLLocationDegrees(i.longitude)!, message: i.message, date: i.timestamp, userName: i.creator_username, userId: i.creator_id, messageId: i.message_id, likeCount: i.like_count, dislikeCount: i.dislike_count)
                                DropManager.add(drop: new)
                            }
                            
                            performUIUpdatesOnMain {
                                self.tableView.reloadData()
                            }
                        }
                        return
                    default:
                        let parsedResult = try JSONDecoder().decode(SuccessResponse.self, from: data)
                        print("PARSED RESULT:",parsedResult)
                    }
                
 
            } catch let err {
                print(err)
            }
        }
        
        
        task.resume()
    }
    


}

