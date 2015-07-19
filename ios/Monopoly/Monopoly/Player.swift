//
//  Player.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/18/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

class Player {
    var id : Int
    //var user_id : Int
    var name : String
    var cash : Int
    var in_jail : Bool
    var position : Int
    
    var user : User?
    
    init(id: Int, name: String, cash: Int, in_jail: Bool, position: Int) {
        self.id = id
        self.name = name
        self.cash = cash
        self.in_jail = in_jail
        self.position = position
    }
    
}
