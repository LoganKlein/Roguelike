//
//  JSONHelper.swift
//  Roguelike
//
//  Created by Logan Klein on 11/17/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class JSONHelper: NSObject {
    class func getArrayFromFile(name: String) -> [NSDictionary] {
        if let path = NSBundle.mainBundle().pathForResource(name, ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMappedIfSafe)
                
                do {
                    let json: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [NSDictionary]
                    return json
                }
                    
                catch {
                    print("error serializing JSON: \(error)")
                }
            }
                
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
            
        else {
            print("Invalid filename/path.")
        }
        
        return []
    }
}
