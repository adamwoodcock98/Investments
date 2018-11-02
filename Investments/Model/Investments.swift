//
//  Investments.swift
//  Investments
//
//  Created by Adam Woodcock on 17/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Investments : Object {
    
    @objc dynamic var id : String!
    @objc dynamic var title : String!
    @objc dynamic var investmentDescription : String?
    @objc dynamic var dayStarted : Int = 0
    @objc dynamic var monthStarted : Int = 0
    @objc dynamic var yearStarted : Int = 0
    let dayEnded = RealmOptional<Int>()
    let monthEnded = RealmOptional<Int>()
    let yearEnded = RealmOptional<Int>()
    @objc dynamic var isInterestVariable : Bool = false
    let interestRate = RealmOptional<Double>()
    @objc dynamic var interestFrequency : String?
    @objc dynamic var initialInvestment : Double = 0.0
    @objc dynamic var withdrawalsAvailable : Bool = true
    @objc dynamic var runningTotal : Double = 0.0
    var gains = List<Gains>()
    @objc dynamic var mostRecentGain : Double = 0.0
    var withdrawals = List<Withdrawals>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class Gains : Object {
    
    @objc dynamic var timestamp : Date?
    @objc dynamic var percentage : Double = 0.0
    let parent = LinkingObjects(fromType: Investments.self, property: "gains")
    
}

class Withdrawals : Object {
    
    @objc dynamic var timestamp : Date?
    @objc dynamic var amount : Double = 0.0
    let parent = LinkingObjects(fromType: Investments.self, property: "withdrawals")
    
}
