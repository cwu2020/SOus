//
//  MeViewController.swift
//  Sous
//
//  Created by Summer Wu on 4/23/15.
//  Copyright (c) 2015 buz. All rights reserved.
//

import UIKit
import Parse

class MeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var proPic: UIImageView!
    
    var user = PFUser.currentUser()
    
    @IBOutlet var userName: UILabel!

    @IBOutlet var joinDate: UILabel!
    
    @IBAction func changeProPic(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let imageFile = PFFile(name:"image.jpeg", data:imageData)
        imageFile.saveInBackground()
        
        user.setObject(imageFile, forKey: "profilePic")
        
        user.saveInBackground()

        proPic.image = image
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userImageFile = user.objectForKey("profilePic") as PFFile
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data:imageData)
                self.proPic.image = image
            }
        }
        
        let date = user.createdAt //get the time, in this case the time an object was created.
        //format date
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(date)
        println(dateString) //prints out 10:12

        joinDate.text = dateString
        
       userName.text = "\(PFUser.currentUser().username)"

        // Do any additional setup after loading the view.
        proPic.layer.cornerRadius = proPic.frame.size.height/2;
        proPic.layer.masksToBounds = true;
        proPic.layer.borderWidth = 2;
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
