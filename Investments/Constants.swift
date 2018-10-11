//
//  Constants.swift
//  Investments
//
//  Created by Adam Woodcock on 10/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import Foundation
import UIKit

class Constants : NSObject {
    
    //Array constants for PickerView data
    static let pickerWeeksNumbers = [1, 2, 3, 4]
    static let pickerMonthsNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48]
    static let pickerComponent2 = ["Weeks", "Months"]
    
    //Function to convert TextField data to currency, also returning an integer value to pass forward to the results controller
    static func convertStringToFormattedString(input: String) -> (integerValue: Int, stringValue: String) {
        let integer = Int(input) ?? 0
        let number = NSNumber(value: integer)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.generatesDecimalNumbers = false
        
        
        return (integer, "£\(formatter.string(from: number)!)")
    }
    
    
}

//Extension of the ViewController class to dismiss keyboards when tapping around
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

