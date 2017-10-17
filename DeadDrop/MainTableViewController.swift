//
//  MainTableViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/10.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class MainTableViewController: UITableViewController {
    
    //var dropArray:[Drop] = [Drop]()
    
    func addTapped(){
        performSegue(withIdentifier: "tableToPost", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DropManager.init()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("dropArray.count:\(DropManager.drops.count)\n")
        self.tableView.reloadData()
        getData()
        
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
        guard let url = URL(string: "localhost:3000/api/message") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode([Data].self, from: data)
//                for user in users {
//                    print(user.address.geo.lat)
//                }
                print("data:\(data)")
                
            } catch {}
        }
        task.resume()
    }

}
