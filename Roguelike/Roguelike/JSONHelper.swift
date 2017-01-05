//
//  JSONHelper.swift
//  Roguelike
//
//  Created by Logan Klein on 11/17/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class JSONHelper: NSObject {
    class func getArrayFromFile(_ name: String) -> [NSDictionary] {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                do {
                    let json: [NSDictionary] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [NSDictionary]
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
