//
//  MainViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/27.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, SettingsLauncherDelegate {
    
    // MARK: - Properites
    
    let manager = CLLocationManager() // This is for getting user's current location
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var currLocation:CLLocation?
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func addBtnAction(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let blackView = UIView()
    let settingsLauncher = SettingsLauncher()
    
    @IBAction func refreshBtnAction(_ sender: UIButton) {
        
        settingsLauncher.showSettings()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RangeSlideBar") as! RangeSlideBarViewController
//        print("A")
//        navigationController?.pushViewController(vc, animated: true)
//        print("B")

//        performSegue(withIdentifier: "toRange", sender: self)
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.blackView.alpha = 0
            // dismisses blackView
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent position
        
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
        
    }
    
    func viewDidAppear() {

        
        //self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBtn.layer.cornerRadius = 0.5 * addBtn.bounds.size.width
        addBtn.clipsToBounds = true
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
        settingsLauncher.delegate = self
        
        //https://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
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
            performSegue(withIdentifier: "toRange", sender: nil)
            print("Found account")
        case .logout:
            print("logging out")
        case .cancel:
            print("Cancel")
        }
    }
    
//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch (segue.identifier) {
//        case "toRange":
//            guard let setting = sender as? EnumSetting else {
//                return
//            }
//        }
//        if segue.identifier == "toRange"
//    }
    
    func doSomething(refreshControl: UIRefreshControl) {
        
        getData(latitude: latitude!, longitude: longitude!)
        tableView.reloadData()
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.usernameLabel.text = i.userName
        cell.timeLabel.text = i.date
//        let convertTest = convertStringToDate(dateString: i.date!)
//        print("CONVERT RESULT:\(String(describing: convertTest))")
        
        let messageLocation = CLLocation(latitude: i.latitude, longitude: i.longtitude)
//        print("i LAT:\(i.latitude), i LONG:\(i.longtitude)")
//        print("\(latitude), \(longitude)")
        let distance = currLocation?.distance(from: messageLocation)
        
        cell.messageLabel.text = "\(String(describing: i.message!))"
//        let messageDate = convertStringToDate(dateString: i.message)
        
        if distance! < 1.0{
            cell.distanceLabel.text = "Near here"
        } else {
            cell.distanceLabel.text = "\(Int(distance!))m"
        }
        
        return cell
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
                            print("ALERT VIEW")
                            
                            let package = try JSONDecoder().decode(Package.self, from: data)
                            
                            let messages = package.data.messages
                            
                            DropManager.clearAll() // clean Drops to prevent multiple loads
                            
                            for i in messages {
                                let new = Drop.init(lat: CLLocationDegrees(i.latitude)!, long: CLLocationDegrees(i.longitude)!, message: i.message, date: i.timestamp, userName: i.creator_username, userId: i.creator_id )
                                DropManager.add(drop: new)
                            }
                            
                            performUIUpdatesOnMain {
                                self.tableView.reloadData()
//                                self.activityIndicator.stopAnimating()
//                                print("B")
                                
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                }

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
        
//        performUIUpdatesOnMain{
//            self.tableView.reloadData()
//            self.activityIndicator.stopAnimating()
//        }
        
        task.resume()
    }
    


}

