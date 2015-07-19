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
        
       
    }
    
    @IBAction func refresh() {
        Http.get("http://localhost:3000/api/v1/users/" + String(Globals.user_id) + "/games") { (succeeded: Bool, response: NSArray) -> () in                            //self.games.removeAll()
            var msg = ""
            //println("--------------")
            //println("Returned array")
            if let game_dict = response[0] as? NSDictionary {
                
                
                let game = Game(id: game_dict["id"] as! Int, current_player_id: game_dict["current_player_id"] as! Int, status: game_dict["status"] as! String)
                
                
                if let players_arr = game_dict["players"] as? NSArray {
                    //println(players[0]["name"])
                    //msg = players[0]["name"] as! String
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
            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")

            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> () in
                // Show the alert

                self.tableView.reloadData()
                alert.show()
                
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Called numberOfRowsInSection")
        return games.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("called cellforRowAtIndexPath")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}