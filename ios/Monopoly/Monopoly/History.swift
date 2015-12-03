//
//  History.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/19/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//
import UIKit

class History {
    var id: Int
    var details: String
    var created_at_formatted: String
    
    init (id: Int, details: String, created_at_formatted: String) {
        self.id = id
        self.details = details
        self.created_at_formatted = created_at_formatted
    }
    
    static func historyFromDict(dict: NSDictionary) -> History {
        return History(
            id: dict["id"] as! Int,
            details: dict["details"] as! String,
            created_at_formatted: dict["created_at_formatted"] as! String
        )
    }
    
}
