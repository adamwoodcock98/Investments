//
//  PickerWithDesignables.swift
//  Investments
//
//  Created by Adam Woodcock on 08/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit

class PickerWithDesignables: UIDatePicker {
    
//    @IBInspectable var textColour : UIColor? {
//
//        didSet {
//            setValue(textColour, forKey: "textColor")
//            setValue(textColour, forKey: "highlightsToday")
//        }
//    }
    
    var changed = false
    override func addSubview(_ view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor(hexString: "E7E5E5"), forKey: "textColor")
        }
        super.addSubview(view)
    }

    
    
}
