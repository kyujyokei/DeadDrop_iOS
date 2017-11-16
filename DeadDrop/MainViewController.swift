//
//  MainViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/27.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let manager = CLLocationManager() // This is for getting user's current location
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func addBtnAction(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let blackView = UIView()
    let settingsLuancher = SettingsLauncher()
    
    @IBAction func refreshBtnAction(_ sender: UIButton) {
        
        settingsLuancher.showSettings()
//        performSegue(withIdentifier: "return", sender: nil)
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
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        //self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBtn.layer.cornerRadius = 0.5 * addBtn.bounds.size.width
        addBtn.clipsToBounds = true
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
        //https://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
    }
    
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
        
        cell.timeLabel.text = "5 mins ago"
        cell.distanceLabel.text = "200m"
        
        cell.messageLabel.text = "\(String(describing: i.message!))"
        
        return cell
    }
    
    public func getData(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        
        print("get")
        guard let url = URL(string: "https://deaddrop.live/api/message?latitude=\(latitude)&longitude=\(longitude)&range=\(UserDefaults.standard.integer(forKey: "range"))") else { return }
        
        print(url)
        
        print("latitude:",String(describing: latitude)," ,longitude:",String(describing: longitude))
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, err) in
            guard let data = data, let response = response else { return }
            
            do {
                let package = try JSONDecoder().decode(Package.self, from: data)

                let messages = package.data.messages
                
                DropManager.clearAll() // clean Drops to prevent multiple loads
                
                for i in messages {
                    let new = Drop.init(lat: CLLocationDegrees(i.latitude)!, long: CLLocationDegrees(i.longitude)!, message: i.message)
                    DropManager.add(drop: new)
                }

                
            } catch let err {
                print(err)
            }
        }
        
        performUIUpdatesOnMain{
            //        let vc = MainViewController()
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        task.resume()
    }
    


}

