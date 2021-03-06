//
//  ViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/1.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let manager = CLLocationManager() // This is for getting user's current location
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    
    var currentLocation:CLLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageVBottom: NSLayoutConstraint!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel! // This is the location label for testing
    
    
    @IBAction func closeWinBtnAct(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageVBottom.constant = -200
        }, completion: nil)
    }
    
    
  
    
    @IBAction func postButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toPost", sender: self)
    }
    
    @IBAction func refreshBtnAction(_ sender: UIButton) {
        getData(latitude: latitude!, longitude: longitude!)
    }
    
    @IBAction func listBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // Get the current location of user
    // This function will be called everytime when our user changes their location
    // @params: locations : an array that stores locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0] // the most recent position
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        // span is for how much we want our map to be zoomed
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        self.mapView.showsUserLocation = true // creates the blue dot on the map
        
        getData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setTestAnnotation() //sets the testing annotation
        mapView.delegate = self
    
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest // get the most accurate data
        manager.requestWhenInUseAuthorization() // request the location when user is using our app, not in backgroud
        manager.startUpdatingLocation()
        
        messageVBottom.constant = -200
        
        postButton.layer.cornerRadius = 0.5 * postButton.bounds.size.width
        postButton.clipsToBounds = true
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //print(message)
    }

    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let Destination : PostViewController = segue.destination as! PostViewController

        //Destination.recentItemId = itemIdArray[selectedNumber]
    }
    
    func setTestAnnotation(){
        
        let latitude: CLLocationDegrees = 44.563781
        let longtitude: CLLocationDegrees = -123.279444
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake( latitude , longtitude )
        let xScale: CLLocationDegrees = 0.01
        let yScale: CLLocationDegrees = 0.01
        let span: MKCoordinateSpan = MKCoordinateSpanMake( xScale , yScale )
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Noname"
        annotation.subtitle = "\"MySQL is the most popular Open Source Relational SQL Database Management System. MySQL is one of the best RDBMS being used for developing various web-based software applications. MySQL is developed, marketed and supported by MySQL AB, which is a Swedish company. This tutorial will give you a quick start to MySQL and make you comfortable with MySQL programming.\""
        
        mapView.addAnnotation(annotation)

    }
    
    
    // When you select an annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.messageVBottom.constant = 0
        }, completion: nil)
        
        print("PIN SELECTED")
        let username = view.annotation?.title
        let message = view.annotation?.subtitle

        if let userText = username {
            usernameLabel.text = userText
            messageLabel.text = message!
        } else {
            messageLabel.text = nil
        }
        
        
    }

    
    func getData(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        
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

                    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake( Double(i.latitude)! , Double(i.longitude)! )
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = location
                    var annotation = CustomAnnotation(title: i.message, date: i.timestamp, subtitle: i.creator_username, userId: i.creator_id, messageId: i.message_id, likeCount: i.like_count, dislikeCount: i.dislike_count, coordinate: location)
//                    annotation.coordinate = location
//                    annotation.title = new.message
                    self.mapView.addAnnotation(annotation)
                }
                
                
            } catch let err {
                print(err)
            }
        }
        
        performUIUpdatesOnMain{

        }
        
        task.resume()
    }


}

