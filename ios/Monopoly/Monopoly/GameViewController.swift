//
//  GameViewController.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/19/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refresh()
        

    }
    
    @IBAction func home() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func refresh() {
        Globals.refreshGame { (succeeded) -> () in
            var statusText = ""
            
            if let game = Globals.game {
                for player in game.players {
                    statusText += player.name + " " + String(player.cash) + "\n"
                }
                dispatch_async(dispatch_get_main_queue(), { () -> () in
                    // Show the alert
                    self.statusLabel.text = statusText
                })
                
            }
        }
    }
    
    @IBAction func showHistory() {
        performSegueWithIdentifier("showHistorySegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistorySegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! HistoryViewController
            
            //controller.delegate = self
        }
    }
}
