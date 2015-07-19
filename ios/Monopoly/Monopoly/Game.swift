//
//  Game.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/18/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

class Game {
    var id: Int
    var current_player_id: Int
    var status : String
    var players : [Player]
    
    init(id: Int, current_player_id: Int, status: String) {
        self.id = id
        self.current_player_id = current_player_id
        self.status = status
        self.players = [Player]()
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
