//
//  Game.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/18/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//
import UIKit

class Game {
    var id: Int
    var current_player_id: Int
    var status : String
    var players : [Player]
    var history : [History]
    
    init(id: Int, current_player_id: Int, status: String) {
        self.id = id
        self.current_player_id = current_player_id
        self.status = status
        self.players = [Player]()
        self.history = [History]()
    }

    static func gameFromDict(dict: NSDictionary) -> Game {
        let game = Game(id: dict["id"] as! Int, current_player_id: dict["current_player_id"] as! Int, status: dict["status"] as! String)
        
        if let players_arr = dict["players"] as? NSArray {
            for player_dict in players_arr {
                
                let player = Player(id: player_dict["id"] as! Int, name: player_dict["name"] as! String, cash: player_dict["cash"] as! Int, in_jail: player_dict["in_jail"] as! Bool, position: player_dict["position"] as! Int)
                
                if let user_dict = player_dict["user"] as? NSDictionary {
                    let user = User(id: user_dict["id"] as! Int, email: user_dict["email"] as! String)
                    
                    player.user = user
                }
                
                game.players.append(player)
            }
        }
        
        if let history_arr = dict["history"] as? NSArray {
            for history_dict in history_arr {
                game.history.append(History.historyFromDict(history_dict as! NSDictionary))
            }
        }
        
        return game
    }
    
    func currentPlayersName() -> String {
        for player in players {
            if player.id == id {
                return player.name
            }
        }
        return "N/A" // TODO: throw error?
    }
    
    
}
