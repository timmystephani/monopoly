//
//  ViewController.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/18/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    
  
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextView.text = "timmy.stephani@gmail.com"
        passwordTextView.text = "password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn() {
        
        print("log in clicked")
        print(emailTextView.text)
        //var alert = UIAlertView(title: "Success!", message: "hi", delegate: nil, cancelButtonTitle: "Okay.")
        //alert.show()
        var params: NSMutableDictionary = ["user":Dictionary<String, String>()]
        params["user"] = ["email": emailTextView.text, "password": passwordTextView.text]
        
        Http.post(params, url: "http://localhost:3000/api/v1/users/auth_token") { (succeeded: Bool, response: NSDictionary) -> () in
            //var alert = UIAlertView(title: "Success!", message: "hi", delegate: nil, cancelButtonTitle: "Okay.")
            // alert.show()

            Globals.auth_token = response["auth_token"] as! String
            Globals.user_id = response["id"] as! Int
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                // Show the alert
                self.performSegueWithIdentifier("showHomeSeque", sender: self)
            })
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHomeSeque" {
            let navigationController = segue.destinationViewController as! UINavigationController

            let controller = navigationController.topViewController as! HomeViewController

            //controller.delegate = self
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

}

