//
//  NewInvestmentViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 29/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import ChameleonFramework

class NewInvestmentViewController: UIViewController {
    
    @IBOutlet weak var investmentTitleTextField: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var interestView: UIView!
    @IBOutlet weak var fixedButtonOutlet: UIButton!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var frequencyView: UIView!
    @IBOutlet weak var weeklyButtonOutlet: UIView!
    @IBOutlet weak var withdrawalsView: UIView!
    @IBOutlet weak var yesButtonOutlet: UIButton!
    @IBOutlet weak var investmentAmountView: UIView!
    @IBOutlet weak var investmentAmountTextField: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dismissKeyboard()
        configureUI()
    }
    
    //MARK: - Functions
    
    //Function to configure the view for loading
    func configureUI() {
        investmentTitleTextField.borderStyle = .none
        investmentTitleTextField.layer.borderWidth = 2
        investmentTitleTextField.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        investmentTitleTextField.layer.cornerRadius = 8
        investmentTitleTextField.setLeftPadding(10)
        investmentTitleTextField.delegate = self
        descriptionView.layer.borderWidth = 2
        descriptionView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        descriptionView.layer.cornerRadius = 8
        descriptionView.dismissKeyboard()
        descriptionTextField.delegate = self
        startDateView.layer.borderWidth = 2
        startDateView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        startDateView.layer.cornerRadius = 8
        startDateView.dismissKeyboard()
        endDateView.layer.borderWidth = 2
        endDateView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        endDateView.layer.cornerRadius = 8
        endDateView.dismissKeyboard()
        interestView.layer.borderWidth = 2
        interestView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        interestView.layer.cornerRadius = 8
        interestView.dismissKeyboard()
        fixedButtonOutlet.layer.cornerRadius = 5
        rateView.layer.borderWidth = 2
        rateView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        rateView.layer.cornerRadius = 8
        rateView.dismissKeyboard()
        frequencyView.layer.borderWidth = 2
        frequencyView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        frequencyView.layer.cornerRadius = 8
        frequencyView.dismissKeyboard()
        weeklyButtonOutlet.layer.cornerRadius = 5
        withdrawalsView.layer.borderWidth = 2
        withdrawalsView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        withdrawalsView.layer.cornerRadius = 8
        withdrawalsView.dismissKeyboard()
        yesButtonOutlet.layer.cornerRadius = 5
        investmentAmountView.layer.borderWidth = 2
        investmentAmountView.layer.borderColor = UIColor(hexString: "f5b316")?.cgColor
        investmentAmountView.layer.cornerRadius = 8
        investmentAmountView.dismissKeyboard()
        
    }

}

//MARK: - Textfield and Textview Delegate Methods
extension NewInvestmentViewController : UITextViewDelegate, UITextFieldDelegate {
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        UIView.animate(withDuration: 0.3) {
//            self.view.frame.origin.y = 0 - self.investmentTitleTextField.frame.origin.y + 10
//            self.view.layoutIfNeeded()
//        }
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == investmentTitleTextField {
            descriptionTextField.becomeFirstResponder()
            return true
        } else {
            self.resignFirstResponder()
            return true
        }
    }
}
