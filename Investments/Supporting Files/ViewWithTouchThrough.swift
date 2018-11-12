//
//  ViewWithTouchThrough.swift
//  Investments
//
//  Created by Adam Woodcock on 09/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit

class ViewWithTouchThrough: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

class ViewWithoutTouchThrough: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
}

class ButtonWithoutTouchThrough : UIButton {
    
}
