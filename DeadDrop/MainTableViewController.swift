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
    
    //var dropArray:[Drop] = [Drop]()
    
    let manager = CLLocationManager() // This is for getting user's current location
    var latitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent position
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    @objc func addTapped(){
        performSegue(withIdentifier: "tableToPost", sender: self)
    }
    
    @objc func refreshView(){
        print(DropManager.drops)
        getData()
        print(DropManager.drops)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self as CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
        
        refreshView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DropManager.init()
        
        refreshView()
        self.tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(refreshView))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print("dropArray.count:\(DropManager.drops.count)\n")
        self.tableView.reloadData()

        
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
        
        print("DropCount:",DropManager.drops.count)
        
        let i = DropManager.drops[indexPath.row]
        
        cell.textLabel?.text = "lat:\(i.latitude),long:\(i.longtitude),message:\(String(describing: i.message!))"
        
        //print(String((cell.textLabel?.text!)!)!)
        
        return cell
    }
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PostViewController {
//            dataRecieved = sourceViewController.dataPassed
//            DropManager.add(drop: sourceViewController.newDrop)
        }
    }

    func getData() {
        
        print("get")
        guard let url = URL(string: "http://localhost:443/api/message?latitude=\(String(describing: latitude))&longitude=\(String(describing: longitude))&range=100") else { return }
        
        print(url)
        
        print("latitude:",String(describing: latitude)," ,longitude:",String(describing: longitude))
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let package = try JSONDecoder().decode(Package.self, from: data)
//                for i in package.data.messages {
//                    print(package.data.messages)
                let messages = package.data.messages
                
                DropManager.clearAll() // clean Drops to prevent multiple loads
                
                for i in messages {
//                    print(i)
                    let new = Drop.init(lat: CLLocationDegrees(i.latitude)!, long: CLLocationDegrees(i.longitude)!, message: i.message)
                    DropManager.add(drop: new)
//                    print(DropManager.drops.count)
                }
//                    print()
//                }
                
            } catch let err {
                print(err)
            }
        }
        self.tableView.reloadData()
        
        task.resume()
    }

}
