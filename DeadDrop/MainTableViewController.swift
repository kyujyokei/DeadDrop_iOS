//
//  MainTableViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/10.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class MainTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let manager = CLLocationManager() // This is for getting user's current location
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent position
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        getData(latitude: latitude!, longitude: longitude!)
    }
    
    @objc func addTapped(){
        performSegue(withIdentifier: "tableToPost", sender: self)
    }
    
    @objc func refreshView(){
//        print(DropManager.drops)
        getData(latitude: latitude!, longitude: longitude!)
        tableView.reloadData()
//        print(DropManager.drops)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        DropManager.init()
//        getData()
        
        manager.delegate = self as CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
        
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this allows table view to have dynamic height base on the contents of labels
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshView))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DropManager.drops.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
//    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? PostViewController {
////            dataRecieved = sourceViewController.dataPassed
////            DropManager.add(drop: sourceViewController.newDrop)
//        }
//    }

    
}
