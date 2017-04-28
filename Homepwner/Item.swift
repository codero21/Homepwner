//
//  Item.swift
//  Homepwner
//
//  Created by Rollin Francois on 4/7/17.
//  Copyright © 2017 Francois Technology. All rights reserved.
//


import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String
    var dateCreated: Date
    let itemKey: String
    
    // Conform to NSCoding Protocol
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        serialNumber = (aDecoder.decodeObject(forKey: "serialNumber") as! String?)!
        
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        
        super.init()
    }
    
    
    // Dedicated Initializer
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber!
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bears","Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSeriallNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName,
                      serialNumber: randomSeriallNumber,
                      valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
}
