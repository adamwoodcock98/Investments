//
//  ViewWithDesignables.swift
//  Investments
//
//  Created by Adam Woodcock on 08/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit

class ViewWithDesignables: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
    
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderWidth : CGFloat = 0 {
        
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColour : UIColor? {
        
        didSet {
            layer.borderColor = borderColour?.cgColor
        }
    }
}
