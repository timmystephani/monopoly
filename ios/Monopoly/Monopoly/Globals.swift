//
//  Globals.swift
//  Monopoly
//
//  Created by Tim Stephani on 7/18/15.
//  Copyright (c) 2015 Tim Stephani. All rights reserved.
//

import Foundation

class Globals {
    static var auth_token: String = ""
    static var user_id: Int = 0
    static var game: Game?
    static let BASE_URL = "http://localhost:3000/"
    
    
    static func refreshGame(postCompleted : (succeeded: Bool) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/api/v1/games/" + String(game!.id))!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        //println("Url: " + url)
        
        var err: NSError?
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Token " + Globals.auth_token, forHTTPHeaderField: "Authorization")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body:")
            println(strData)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                println("Error could not parse JSON: '\(strData)'")
                //postCompleted(succeeded: false, msg: "Error")
            }
            else {
                
                if let parseJSON = json {
                    Globals.game = Game.gameFromDict(parseJSON)
                    postCompleted(succeeded: true)
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    //postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
}