//
//  PageItemController.swift
//  Sous
//
//  Created by Summer Wu on 3/19/15.
//  Copyright (c) 2015 buz. All rights reserved.
//

import UIKit
import Parse


class PageItemController: UIViewController, UITextFieldDelegate {
    
        // MARK: - Variables //
    var itemIndex = Int(0)
    var signUpActive = true
    var imageName: String = ""  {
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
                
            }
            
        }
    }
   
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    

    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }


    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var facebookSignUpButton: UIButton!
    
    @IBOutlet weak var alreadyRegistered: UILabel!
    
    @IBAction func facebookSignUp(sender: AnyObject) {
        
        var permissions = ["public_profile"]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })

    }
    
    
    
    @IBAction func logInToggle(sender: AnyObject) {
        
       // performSegueWithIdentifier("logInFromToggle", sender: self)
        
        if signUpActive == true {
            
               signUpActive = false
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Don't have an account yet?"
            
            facebookSignUpButton.setTitle("Log In with", forState: UIControlState.Normal)
            
            logInToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
        } else {
            
            signUpActive = true
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            alreadyRegistered.text = "Already have an account?"
            
            facebookSignUpButton.setTitle("Sign Up with", forState: UIControlState.Normal)
            
            logInToggleButton.setTitle("Log In", forState: UIControlState.Normal)
        }

        
    }
    
    @IBOutlet weak var logInToggleButton: UIButton!
    
    @IBAction func signUp(sender: AnyObject) {
    
        
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "Please enter a username and password."
            
        } else if countElements(username.text) < 6 || countElements(password.text) < 6 {
            
            error = "Username and password must each contain 6 or more characters."
        }
        
        if error != "" {
            
            displayAlert("Error in Form", error: error)
            
        } else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signUpActive == true {
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool!, signUpError: NSError!) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if signUpError == nil {
                    
                    println("signed up")
                    
                    self.performSegueWithIdentifier("logInToHome", sender: self)
                    
                    
                } else {
                    
                    if let errorString = signUpError.userInfo?["error"] as? NSString {
                        
                        error = errorString
                        
                    } else {
                        error = "Please try again later"
                    }
                    
                    self.displayAlert("Could Not Sign Up", error: error)
                    
                }
            }
            
            } else {
                
                                PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                                    (user: PFUser!, signUpError: NSError!) -> Void in
                                    if signUpError == nil {
                
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                                        self.performSegueWithIdentifier("logInToHome", sender: self)
                
                
                                    } else {
                
                                        if let errorString = signUpError.userInfo?["error"] as? NSString {
                
                                            error = errorString
                
                                        } else {
                                            error = "Please try again later"
                                        }
                                        
                                        self.displayAlert("Could Not Log In", error: error)
                                        
                                    }
                                }
            }

        
        
        
        
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        println(PFUser.currentUser())
        
        self.username.delegate = self
        self.password.delegate = self
        
        if itemIndex != 3 {
            username.hidden = true
            password.hidden = true
            signUpButton.hidden = true
            logInToggleButton.hidden = true
            facebookSignUpButton.hidden = true
            alreadyRegistered.hidden = true
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
        
        alreadyRegistered.text = "Already have an account?"
        
        facebookSignUpButton.setTitle("Sign Up with", forState: UIControlState.Normal)
        
        logInToggleButton.setTitle("Log In", forState: UIControlState.Normal)
        
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(sender: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { self.view.frame.origin.y -= 115 }, completion: nil)
    }
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(1.0, animations: { self.view.frame.origin.y += 115 }, completion: nil)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
//        if PFUser.currentUser() != nil {
//            self.performSegueWithIdentifier("logInToHome", sender: self)
//        }
    }
    
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
