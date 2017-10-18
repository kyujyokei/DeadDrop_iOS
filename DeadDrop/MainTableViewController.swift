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
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent position
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    @objc func addTapped(){
        performSegue(withIdentifier: "tableToPost", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager.delegate = self as CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DropManager.init()

        
        getData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
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

        let i = DropManager.drops[indexPath.row]
        
        cell.textLabel?.text = "lat:\(i.latitude),long:\(i.longtitude),message:\(String(describing: i.message!))"
        
        //print(String((cell.textLabel?.text!)!)!)
        
        return cell
    }
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PostViewController {
//            dataRecieved = sourceViewController.dataPassed
            DropManager.add(drop: sourceViewController.newDrop)
        }
    }

    func getData() {
        print("get")
        guard let url = URL(string: "http://localhost:443/api/message?latitude=44.5680134&longitude=-123.28739800000001&range=100") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                print("A")
                let package = try JSONDecoder().decode(Package.self, from: data)
//                for user in users {
                    print(package)
//                    print()
//                }
                
            } catch {}
        }
        task.resume()
    }

}
