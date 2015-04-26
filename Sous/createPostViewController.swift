//
//  createPostViewController.swift
//  Sous
//
//  Created by Summer Wu on 4/23/15.
//  Copyright (c) 2015 buz. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import Parse

class createPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var user = PFUser.currentUser()
    var manager = CLLocationManager()
    
    var address = "Click Find Me"
    
    @IBOutlet var foodType: UITextField!
    
    @IBOutlet var servings: UITextField!
    
    @IBOutlet var freshness: UISlider!
    
    @IBOutlet var location: UILabel!
 
    @IBAction func chooseFoodPhoto(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var foodPhoto: UIImageView!
    
    var imageFile = PFFile()
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        self.imageFile = PFFile(name:"image.jpeg", data:imageData)
        self.imageFile.saveInBackground()
        
        foodPhoto.image = image
        
    }
    
    
    @IBAction func findMe(sender: AnyObject) {
        
        location.text = address
        
    }
    
    @IBAction func postButton(sender: AnyObject) {
        
        var post = PFObject(className:"Posts")
        post["foodType"] = foodType.text
        post["servings"] = servings.text
        post["freshness"] = freshness.value
        post["location"] = postLocation
//        post["foodPic"] = imageFile
        post["username"] = user
        
        post.setObject(imageFile, forKey: "foodPic")

        post.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.performSegueWithIdentifier("postToFeed", sender: self)
                
            } else {
                println(error)
                
            }
        }
        
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        if user.objectForKey("profilePic") != nil {
//            
//            let userImageFile = user.objectForKey("profilePic") as PFFile
//            
//            userImageFile.getDataInBackgroundWithBlock {
//                (imageData: NSData!, error: NSError!) -> Void in
//                if error == nil {
//                    let image = UIImage(data:imageData)
//                    self.proPic.image = image
//                }
//            }
//        } else {
//            
//            proPic.image = UIImage(named: "userGeneric.png")
//            
//            
//        }
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        }
    
    var postLocation = PFGeoPoint()
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation:CLLocation = locations[0] as CLLocation
        println(locations)
        
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        var longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        manager.stopUpdatingLocation()
        
        self.postLocation = PFGeoPoint(location: userLocation)

        
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:{(placemarks, error) in
            
            if error != nil { println("ERROR: \(error)") }
            else {
                let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                var subThoroughfare:String
                var thoroughfare:String
                
                if (p.subThoroughfare) != nil {
                    subThoroughfare = p.subThoroughfare
                } else {
                    subThoroughfare = ""
                }
                
                if (p.thoroughfare) != nil {
                    thoroughfare = p.thoroughfare
                } else {
                    thoroughfare = ""
                }
                
                
                self.address = "\(subThoroughfare) \(thoroughfare)"
                
                if self.address == " " {
                    var date = NSDate()
                    self.address = "Unknown Location added \(date)"
                }
                
            }
            
        })

        
    }
    
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { self.view.frame.origin.y -= 0}, completion: nil)
    }
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { self.view.frame.origin.y += 0 }, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
