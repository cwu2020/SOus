//
//  TableViewController.swift
//  Sous
//
//  Created by Summer Wu on 4/23/15.
//  Copyright (c) 2015 buz. All rights reserved.
//

import UIKit
import CoreLocation
import Parse


class TableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var timelineData:NSMutableArray = NSMutableArray()
    
    var manager = CLLocationManager()

    var user = PFUser.currentUser()
    
    @IBAction func loadData(sender: AnyObject) {
        
        timelineData.removeAllObjects()
        
        var findTimelineData:PFQuery = PFQuery(className: "Posts")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil{
                for object in objects{
                    let post:PFObject = object as PFObject
                    self.timelineData.addObject(post)
                }
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                self.tableView.reloadData()
                
            }
            
        }

        
    }
   
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func viewDidAppear(animated: Bool) {
        
        self.loadData(self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return timelineData.count
    }

    
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as PostTableViewCell
    
            let post:PFObject = self.timelineData.objectAtIndex(indexPath.row) as PFObject
    
    
            cell.addressLabel.alpha = 0
            cell.timeStampLabel.alpha = 0
            cell.usernameLabel.alpha = 0
            cell.foodTypesLabel.alpha = 0
            cell.freshnessLabel.alpha = 0
            
//            if let description = post["foodType"] as? NSString {
//                cell.foodTypesLabel?.text = description
//            }
            
            cell.foodTypesLabel?.text = post.objectForKey("foodType") as? NSString
            cell.addressLabel?.text = post.objectForKey("address") as? NSString
           
            var dataFormatter:NSDateFormatter = NSDateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            cell.timeStampLabel.text = dataFormatter.stringFromDate(post.createdAt)
            
            
            cell.usernameLabel.text = post.objectForKey("user").username

            var a:Double = post.objectForKey("freshness") as Double
            var int = Int(round(a))
            var string = String(int)
            cell.freshnessLabel?.text = "Freshness: \(string)/5"
            
            UIView.animateWithDuration(0.5, animations: {
                cell.foodTypesLabel.alpha = 1
                cell.timeStampLabel.alpha = 1
                cell.usernameLabel.alpha = 1
                cell.addressLabel.alpha = 1
                cell.freshnessLabel.alpha = 1
            })

    
//            var findPost:PFQuery = PFUser.query()
//            findPost.whereKey("objectId", equalTo: post.objectForKey("sweeter").objectId)
    
            
    
    //        findSweeter.findObjectsInBackgroundWithBlock{
    //            (objects:[AnyObject]!, error:NSError!)->Void in
    //            if error == nil{
    //                let user:PFUser = (objects as NSArray).lastObject as PFUser
    //                cell.usernameLabel.text = user.username
    //
    //                UIView.animateWithDuration(0.5, animations: {
    //                    cell.sweetTextView.alpha = 1
    //                    cell.timestampLabel.alpha = 1
    //                    cell.usernameLabel.alpha = 1
    //                })
    //            }
    //        }
    
            
            return cell
            
            
        }
    

}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */