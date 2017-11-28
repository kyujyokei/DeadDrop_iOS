//
//  UserMessageViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/11/26.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class UserMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backBtnAct(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        
//        let messageLocation = CLLocation(latitude: i.latitude, longitude: i.longtitude)
//        let distance = currLocation?.distance(from: messageLocation)
//        print("DISTANCE: ",distance)
        
        cell.messageLabel.text = "\(String(describing: i.message!))"

        
        
        return cell
    }
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var tableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        tableVIew.refreshControl = refreshControl
    }
    
    func doSomething(refreshControl: UIRefreshControl) {
        
        getData()
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    public func getData() {
        
        print("get")
        guard let url = URL(string: "https://deaddrop.live/api/message/user)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.object(forKey: "token") as! String,  forHTTPHeaderField: "x-auth" )
        print(url)

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
                            let new = Drop.init(lat: CLLocationDegrees(i.latitude)!, long: CLLocationDegrees(i.longitude)!, message: i.message, date: i.timestamp, userName: i.creator_username, userId: i.creator_id )
                            DropManager.add(drop: new)
                        }
                        
                        performUIUpdatesOnMain {
                            self.tableVIew.reloadData()
                            //                                self.activityIndicator.stopAnimating()
                            //                                print("B")
                            self.tableVIew.reloadData()
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
