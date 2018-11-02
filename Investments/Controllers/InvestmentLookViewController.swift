//
//  InvestmentLookViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 02/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class InvestmentLookViewController: UIViewController {
    
    @IBOutlet weak var uiLabel: UILabel!
    
    
    let realm = try! Realm()
    var currentInvestment : Investments!
    
    var investmentID : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        uiLabel.text = currentInvestment.id
    }
    
    //MARK: - Functions
    
    
    //Configure the UI and perform any necessary functionality setup.
    func configure() {
        
        //Assigning the currentInvestment variable the realm object associated with the investment ID passed in.
        currentInvestment = realm.object(ofType: Investments.self, forPrimaryKey: investmentID)
        
        //Set navigation bar title as investment title
        self.title = currentInvestment.title
        
        //Set navigation bar back button title
        navigationItem.hidesBackButton = false
    }
    

}


