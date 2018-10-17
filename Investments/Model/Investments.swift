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
    
    @objc dynamic var name: String = "Untitled"
    @objc dynamic var dateStarted : Date?
    @objc dynamic var initialInvestment : Double = 0.0
    @objc dynamic var runningTotal : Double = 0.0
    var gains = List<Gains>()
    @objc dynamic var mostRecentGain : Double = 0.0
    var withdrawals = List<Withdrawals>()
    
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
