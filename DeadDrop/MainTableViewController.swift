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
        DropManager.init()
//        getData()
        
        manager.delegate = self as CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
        
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DropManager.init()
//        getData()

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        print("DropCount:",DropManager.drops.count)
        
        let i = DropManager.drops[indexPath.row]
        
//        cell.textLabel?.text = "lat:\(i.latitude),long:\(i.longtitude),message:\(String(describing: i.message!))"
        cell.textLabel?.text = "\(String(describing: i.message!))"
        
        //print(String((cell.textLabel?.text!)!)!)
        
        return cell
    }
    
//    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? PostViewController {
////            dataRecieved = sourceViewController.dataPassed
////            DropManager.add(drop: sourceViewController.newDrop)
//        }
//    }

    
}
