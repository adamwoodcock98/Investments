//
//  FloatingActionButton.swift
//  Investments
//
//  Created by Adam Woodcock on 06/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButton {
    
    var alphaBefore : CGFloat = 0.00

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        UIView.animate(withDuration: 0.3) {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: -135 * (.pi / 180))
                self.backgroundColor = UIColor(hexString: "f4a914")
            } else {
                self.transform = .identity
                self.backgroundColor = UIColor(hexString: "f5b316")
            }
        }
        
        alphaBefore = alpha
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.4
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = self.alphaBefore
        }
    }

}
