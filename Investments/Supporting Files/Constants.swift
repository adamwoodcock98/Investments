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

//MARK: - Extension for Time Period Value Dictionaries
extension Constants {
    //Dictionary Constants for Results Time Periods
    static let dictionary4Weeks = Array(1...4)
    static let dictionary2Months = Array(1...9)
    static let dictionary3Months = Array(1...13)
    
    static let dictionary4Months = Array(1...17)
    static let dictionary5Months = Array(1...22)
    static let dictionary6Months = Array(1...26)
    
    static let dictionary7Months = Array(1...30)
    static let dictionary8Months = Array(1...35)
    static let dictionary9Months = Array(1...39)
    
    static let dictionary10Months = Array(1...43)
    static let dictionary11Months = Array(1...48)
    static let dictionary12Months = Array(1...52)
    
    static let dictionary13Months = Array(1...56)
    static let dictionary14Months = Array(1...61)
    static let dictionary15Months = Array(1...65)
    
    static let dictionary16Months = Array(1...69)
    static let dictionary17Months = Array(1...74)
    static let dictionary18Months = Array(1...78)
    
    static let dictionary19Months = Array(1...82)
    static let dictionary20Months = Array(1...87)
    static let dictionary21Months = Array(1...91)
    
    static let dictionary22Months = Array(1...95)
    static let dictionary23Months = Array(1...100)
    static let dictionary24Months = Array(1...104)
    
    static let dictionary25Months = Array(1...108)
    static let dictionary26Months = Array(1...113)
    static let dictionary27Months = Array(1...117)
    
    static let dictionary28Months = Array(1...121)
    static let dictionary29Months = Array(1...126)
    static let dictionary30Months = Array(1...130)
    
    static let dictionary31Months = Array(1...134)
    static let dictionary32Months = Array(1...139)
    static let dictionary33Months = Array(1...143)
    
    static let dictionary34Months = Array(1...147)
    static let dictionary35Months = Array(1...152)
    static let dictionary36Months = Array(1...156)
    
    static let dictionary37Months = Array(1...160)
    static let dictionary38Months = Array(1...165)
    static let dictionary39Months = Array(1...169)
    
    static let dictionary40Months = Array(1...173)
    static let dictionary41Months = Array(1...178)
    static let dictionary42Months = Array(1...182)
    
    static let dictionary43Months = Array(1...186)
    static let dictionary44Months = Array(1...191)
    static let dictionary45Months = Array(1...195)
    
    static let dictionary46Months = Array(1...199)
    static let dictionary47Months = Array(1...204)
    static let dictionary48Months = Array(1...208)
}

class Constants2 {
    static let dictionary4Weeks = ["1 Week" : 1, "2 Weeks" : 2, "3 Weeks" : 3, "4 Weeks" : 4]
    static let dictionary2Months = ["1 Week" : 1, "2 Weeks" : 2, "3 Weeks" : 3, "4 Weeks" : 4, "6 Weeks" : 6, "8 Weeks" : 8]
    static let dictionary3Months = ["1 Week" : 1, "2 Weeks" : 2, "4 Weeks" : 4, "6 Weeks" : 6, "8 Weeks" : 8, "3 Months" : 13]
    
    static let dictionary4Months = ["1 Week" : 1, "2 Weeks" : 2, "4 Weeks" : 4, "8 Weeks" : 8, "3 Months" : 13, "4 Months" : 17]
    static let dictionary5Months = ["1 Week" : 1, "4 Weeks" : 4, "8 Weeks" : 8, "3 Months" : 13, "4 Months" : 17, "5 Months" : 22]
    static let dictionary6Months = ["1 Week" : 1, "4 Weeks" : 4, "8 Weeks" : 8, "3 Months" : 13, "4 Months" : 17, "6 Months" : 26]
    
    static let dictionary7Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "4 Months" : 17, "6 Months" : 26, "7 Months" : 30]
    static let dictionary8Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "4 Months" : 17, "6 Months" : 26, "8 Months" : 35]
    static let dictionary9Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "4 Months" : 17, "6 Months" : 26, "9 Months" : 39]
    
    static let dictionary10Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "9 Months" : 39, "10 Months" : 43]
    static let dictionary11Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "9 Months" : 39, "11 Months" : 48]
    static let dictionary12Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "9 Months" : 39, "1 Year" : 52]
    
    static let dictionary13Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "13 Months" : 56]
    static let dictionary14Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "14 Months" : 61]
    static let dictionary15Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "15 Months" : 65]
    
    static let dictionary16Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "16 Months" : 69]
    static let dictionary17Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "17 Months" : 74]
    static let dictionary18Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "18 Months" : 78]
    
    static let dictionary19Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "19 Months" : 82]
    static let dictionary20Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "20 Months" : 87]
    static let dictionary21Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "21 Months" : 91]
    
    static let dictionary22Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "22 Months" : 95]
    static let dictionary23Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "23 Months" : 100]
    static let dictionary24Months = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104]
    
    static let dictionary25Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "25 Months" : 108]
    static let dictionary26Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "26 Months" : 113]
    static let dictionary27Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "27 Months" : 117]
    
    static let dictionary28Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "28 Months" : 121]
    static let dictionary29Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "29 Months" : 126]
    static let dictionary30Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "30 Months" : 130]
    
    static let dictionary31Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "31 Months" : 134]
    static let dictionary32Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "32 Months" : 139]
    static let dictionary33Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "33 Months" : 143]
    
    static let dictionary34Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "34 Months" : 147]
    static let dictionary35Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "35 Months" : 152]
    static let dictionary36Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156]
    
    static let dictionary37Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "37 Months" : 160]
    static let dictionary38Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "38 Months" : 165]
    static let dictionary39Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "39 Months" : 169]
    
    static let dictionary40Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "40 Months" : 173]
    static let dictionary41Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "41 Months" : 178]
    static let dictionary42Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "42 Months" : 182]
    
    static let dictionary43Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "43 Months" : 186]
    static let dictionary44Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "44 Months" : 191]
    static let dictionary45Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "45 Months" : 195]
    
    static let dictionary46Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "46 Months" : 199]
    static let dictionary47Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "47 Months" : 204]
    static let dictionary48Months = ["4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "1 Year" : 52, "2 Years" : 104, "3 Years" : 156, "48 Months" : 208]
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

extension UIView {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}


