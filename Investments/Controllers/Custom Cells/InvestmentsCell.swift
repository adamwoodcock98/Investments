//
//  InvestmentsCell.swift
//  Investments
//
//  Created by Adam Woodcock on 17/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import SwipeCellKit

class InvestmentsCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor(hexString: "F5B316")?.cgColor
        self.layer.borderWidth = 4
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = UIColor.black.cgColor
        
    }
    
}
