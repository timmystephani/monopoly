//
//  HistoryViewController.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/19/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Globals.refreshGame() { (succeeded: Bool) -> () in
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                self.updateUI()
            })
        }
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateUI() {
        if let game = Globals.game {
            var historyText = ""
            for history in game.history {
                historyText += history.created_at_formatted + " - " + history.details + "\n"
            }
            
            historyLabel.text = historyText
        }
        
    }
}

