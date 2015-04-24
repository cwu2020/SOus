//
//  FeedViewController.swift
//  Sous
//
//  Created by Summer Wu on 4/23/15.
//  Copyright (c) 2015 buz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FeedViewController: UIViewController, CLLocationManagerDelegate {

    @IBAction func addPost(sender: AnyObject) {
        
        self.performSegueWithIdentifier("createPost", sender: self)
    }
    
    var manager = CLLocationManager()
    
    @IBOutlet var feedTable: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        

        // Do any additional setup after loading the view.
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as CLLocation
        
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        var longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        manager.stopUpdatingLocation()
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
