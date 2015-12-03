//
//  HomeViewController.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/18/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    var games = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refresh()
       
    }
    
    @IBAction func refresh() {
        Http.get("http://localhost:3000/api/v1/users/" + String(Globals.user_id) + "/games") { (succeeded: Bool, response: NSArray) -> () in
            //self.games.removeAll()
            var msg = ""
            if let game_dict = response[0] as? NSDictionary {
                
                
                let game = Game(id: game_dict["id"] as! Int, current_player_id: game_dict["current_player_id"] as! Int, status: game_dict["status"] as! String)
                
                
                if let players_arr = game_dict["players"] as? NSArray {
                    for player_dict in players_arr {
                        
                        let player = Player(id: player_dict["id"] as! Int, name: player_dict["name"] as! String, cash: player_dict["cash"] as! Int, in_jail: player_dict["in_jail"] as! Bool, position: player_dict["position"] as! Int)
                        
                        if let user_dict = player_dict["user"] as? NSDictionary {
                            let user = User(id: user_dict["id"] as! Int, email: user_dict["email"] as! String)    
                            
                            player.user = user
                        }
                        
                        game.players.append(player)
                    }
                }
                
                self.games.append(game)
                
            }

            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                // Show the alert
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gameCell") as! UITableViewCell
        
        let game = games[indexPath.row]
        
        var playerNames = [String]()
        for player in game.players {
            playerNames.append(player.name)
        }
        
        cell.textLabel!.text = "Game with " + ", ".join(playerNames)
        cell.detailTextLabel!.text = "Started on 05/05/2015" + " - " + game.currentPlayersName() + "'s turn"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            /*
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
            */
        let game = games[indexPath.row]
        Globals.game = game
            
        performSegueWithIdentifier("showGameSegue", sender: self)
            
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGameSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! GameViewController
            
            //controller.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}