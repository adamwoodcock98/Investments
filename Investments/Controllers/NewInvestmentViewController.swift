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
    @IBOutlet weak var finishButtonOutlet: UIButton!
    @IBOutlet weak var startDDTextField: UITextField!
    @IBOutlet weak var startMMTextField: UITextField!
    @IBOutlet weak var startYYTextField: UITextField!
    @IBOutlet weak var endDDTextField: UITextField!
    @IBOutlet weak var endMMTextField: UITextField!
    @IBOutlet weak var endYYTextField: UITextField!
    @IBOutlet weak var interestButtonOutlet: UIButton!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var frequencyButtonOutlet: UIButton!
    @IBOutlet weak var frequencyChangeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var withdrawalsLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var withdrawalButtonOutlet: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var startValidationLabel: UILabel!
    @IBOutlet weak var amountValidationLabel: UILabel!
    @IBOutlet weak var rateValidationLabel: UILabel!
    
    let yellow = "F5B316"
    
    var interestRateIsVariable : Bool!
    var amountViewHeight : CGFloat = 120
    var titleIsValid = false
    var startDDIsValid = false
    var startMMIsValid = false
    var startYYIsValid = false
    var rateIsValid = false
    var amountIsValid = false
    var verifiedFields = 0
    var validTitle = 0
    var validStartDD = 0
    var validStartMM = 0
    var validStartYY = 0
    var validRate = 0
    var validAmount = 0
    var fieldsToVerify = 6
    
    var pickedInvestmentAmount : Double = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    //MARK: - Functions
    
    //Function to configure the view for loading
    func configureUI() {
        investmentTitleTextField.borderStyle = .none
        investmentTitleTextField.layer.borderWidth = 2
        investmentTitleTextField.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        investmentTitleTextField.layer.cornerRadius = 8
        investmentTitleTextField.setLeftPadding(10)
        investmentTitleTextField.delegate = self
        descriptionView.layer.borderWidth = 2
        descriptionView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        descriptionView.layer.cornerRadius = 8
        descriptionView.hideKeyboardWhenTappedAround()
        descriptionTextField.delegate = self
        startDateView.layer.borderWidth = 2
        startDateView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        startDateView.layer.cornerRadius = 8
        startDateView.hideKeyboardWhenTappedAround()
        endDateView.layer.borderWidth = 2
        endDateView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        endDateView.layer.cornerRadius = 8
        endDateView.hideKeyboardWhenTappedAround()
        interestView.layer.borderWidth = 2
        interestView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        interestView.layer.cornerRadius = 8
        interestView.hideKeyboardWhenTappedAround()
        fixedButtonOutlet.layer.cornerRadius = 5
        rateView.layer.borderWidth = 2
        rateView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        rateView.layer.cornerRadius = 8
        rateView.hideKeyboardWhenTappedAround()
        frequencyView.layer.borderWidth = 2
        frequencyView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        frequencyView.layer.cornerRadius = 8
        frequencyView.hideKeyboardWhenTappedAround()
        weeklyButtonOutlet.layer.cornerRadius = 5
        withdrawalsView.layer.borderWidth = 2
        withdrawalsView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        withdrawalsView.layer.cornerRadius = 8
        withdrawalsView.hideKeyboardWhenTappedAround()
        yesButtonOutlet.layer.cornerRadius = 5
        investmentAmountView.layer.borderWidth = 2
        investmentAmountView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        investmentAmountView.layer.cornerRadius = 8
        investmentAmountView.hideKeyboardWhenTappedAround()
        finishButtonOutlet.layer.borderWidth = 2
        finishButtonOutlet.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        finishButtonOutlet.layer.cornerRadius = 8
        startDDTextField.borderStyle = .none
        startMMTextField.borderStyle = .none
        startYYTextField.borderStyle = .none
        startDDTextField.delegate = self
        startMMTextField.delegate = self
        startYYTextField.delegate = self
        endDDTextField.delegate = self
        endMMTextField.delegate = self
        endYYTextField.delegate = self
        endDDTextField.borderStyle = .none
        endMMTextField.borderStyle = .none
        endYYTextField.borderStyle = .none
        rateTextField.borderStyle = .none
        rateTextField.delegate = self
        interestRateIsVariable = false
        amountTextField.borderStyle = .none
        amountTextField.delegate = self
        finishButtonOutlet.isEnabled = false
        validateAll()
        
        
    }
    
    //Selector function to dismiss keyboard
    @objc func hideKeyboard() {
        view.endEditing(true)
        print("end editing")
    }
    
    //Selector function to dismiss alert.
    @objc func okay(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Animate to raise the view
    func raiseView() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0 - self.amountViewHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func validateTitle() {
        if let text = investmentTitleTextField.text {
            if text.count >= 1 {
                titleIsValid = true
            } else {
                titleIsValid = false
                investmentTitleTextField.text = "Enter a valid title"
                investmentTitleTextField.textColor = UIColor.flatWatermelon()
                investmentTitleTextField.layer.borderColor = UIColor.flatWatermelon()?.cgColor
            }
        }
    }
    
    func validateStartDDDate() -> Bool {
        if startDDTextField.text!.count == 2 && startDDTextField.text?.isNumeric == true {
            startDDIsValid = true
            return true
        } else {
            startDDIsValid = false
            startDDTextField.text = ""
            startValidationLabel.text = "Enter valid DD"
            startValidationLabel.textColor = UIColor.flatWatermelon()
            return false
        }
    }
    
    func validateStartMMDate() -> Bool {
        if startMMTextField.text!.count == 2 && startMMTextField.text?.isNumeric == true {
            startMMIsValid = true
            return true
        } else {
            startMMIsValid = false
            startMMTextField.text = ""
            startValidationLabel.text = "Enter valid MM"
            startValidationLabel.textColor = UIColor.flatWatermelon()
            return false
        }
    }
    
    func validateStartYYDate() -> Bool {
        if startYYTextField.text!.count == 2 && startYYTextField.text?.isNumeric == true {
            startYYIsValid = true
            return true
        } else {
            startYYIsValid = false
            startYYTextField.text = ""
            startValidationLabel.text = "Enter valid YY"
            startValidationLabel.textColor = UIColor.flatWatermelon()
            return false
        }
    }
    
    func validateRate() {
        if interestRateIsVariable == false && rateTextField.text!.count >= 1 && rateTextField.text != "0%" {
            rateIsValid = true
        } else {
            rateIsValid = false
        }
    }
    
    func validateAmount() -> Bool {
        if amountTextField.text?.isDecimal == true {
            amountIsValid = true
            if let text = amountTextField.text {
                amountTextField.text = Constants.convertStringToFormattedString(input: text).stringValue
                pickedInvestmentAmount = Constants.convertStringToFormattedString(input: text).doubleValue
            }
            
            return true
        } else {
            amountIsValid = false
            amountValidationLabel.text = "Enter a valid amount"
            amountValidationLabel.textColor = UIColor.flatWatermelon()
            investmentAmountView.layer.borderColor = UIColor.flatWatermelon()?.cgColor
            amountTextField.text = "Format: 0.00"
            amountTextField.textColor = UIColor.flatWatermelon()
            
            return false
        }
    }
    
    func validateAll() {
        if titleIsValid == true {
            validTitle = 1
        } else {
            validTitle = 0
        }
        
        if startDDIsValid == true {
            validStartDD = 1
        } else {
            validStartDD = 0
        }
        
        if startMMIsValid == true {
            validStartMM = 1
        } else {
            validStartMM = 0
        }
        
        if startYYIsValid == true {
            validStartYY = 1
        } else {
            validStartYY = 0
        }
        
        if interestRateIsVariable == false && rateIsValid == true {
            validRate = 1
        } else if interestRateIsVariable == false && rateIsValid == false {
            validRate = 0
        } else {
            validRate = 0
        }
        
        if amountIsValid == true {
            validAmount = 1
        } else {
            validAmount = 0
        }
        
        if rateTextField.isEnabled == true {
            fieldsToVerify = 6
        } else {
            fieldsToVerify = 5
        }
        
        verifiedFields = fieldsToVerify - (validTitle + validStartDD + validStartMM + validStartYY + validRate + validAmount)
        if verifiedFields >= 1 {
            finishButtonOutlet.isEnabled = false
            finishButtonOutlet.setTitle("\(verifiedFields) FIELDS REMAINING", for: .disabled)
            finishButtonOutlet.setTitleColor(UIColor(hexString: "B7B7B7"), for: .disabled)
            finishButtonOutlet.layer.borderColor = UIColor(hexString: "504d4d")?.cgColor
        } else {
            finishButtonOutlet.isEnabled = true
            finishButtonOutlet.setTitle("SAVE", for: .normal)
            finishButtonOutlet.layer.borderColor = UIColor(hexString: yellow)?.cgColor
            finishButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            finishButtonOutlet.backgroundColor = UIColor(hexString: yellow)
        }
        
    }
    
    //MARK: - IBActions
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //When withdrawal tapped change to yes/no
    @IBAction func withdrawalButtonTapped(_ sender: Any) {
        view.resignFirstResponder()
        
        switch withdrawalButtonOutlet.currentTitle {
        case "YES":
            withdrawalButtonOutlet.setTitle("NO", for: .normal)
        default:
            withdrawalButtonOutlet.setTitle("YES", for: .normal)
        }
    }
    
    //When data is valid, tap finish to save the investment as new Realm object and segue to Investment Look.
    @IBAction func finishTapped(_ sender: Any) {
    }
    
    
    
    @IBAction func frequencyTypeTapped(_ sender: Any) {
        view.endEditing(true)
        
        switch frequencyButtonOutlet.currentTitle {
        case "WEEKLY":
            frequencyButtonOutlet.setTitle("2 WEEKLY", for: .normal)
        case "2 WEEKLY":
            frequencyButtonOutlet.setTitle("MONTHLY", for: .normal)
        case "MONTHLY":
            frequencyButtonOutlet.setTitle("QUARTERLY", for: .normal)
        case "QUARTERLY":
            frequencyButtonOutlet.setTitle("BIANNUALLY", for: .normal)
        case "BIANNUALLY":
            frequencyButtonOutlet.setTitle("ANNUALLY", for: .normal)
        case "ANNUALLY":
            frequencyButtonOutlet.setTitle("WEEKLY", for: .normal)
        default: return
        }
    }
    
    
    //When the interest is changed between variable & fixed, rate and frequency are enabled/disabled
    @IBAction func interestTypeTapped(_ sender: Any) {
        view.endEditing(true)
        if interestButtonOutlet.currentTitle == "VARIABLE" {
            interestButtonOutlet.setTitle("FIXED", for: .normal)
            rateTextField.isEnabled = true
            rateTextField.textColor = UIColor(hexString: "E7E5E5")
            frequencyButtonOutlet.isEnabled = true
            frequencyButtonOutlet.backgroundColor = UIColor(hexString: yellow)
            frequencyButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            frequencyChangeLabel.text = "Tap to Change"
            rateView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
            frequencyView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
            interestRateIsVariable = false
        } else if interestButtonOutlet.currentTitle == "FIXED" {
            interestButtonOutlet.setTitle("VARIABLE", for: .normal)
            rateTextField.isEnabled = false
            rateTextField.textColor = UIColor(hexString: "504d4d")
            frequencyButtonOutlet.isEnabled = false
            frequencyButtonOutlet.backgroundColor = UIColor(hexString: "504d4d")
            frequencyButtonOutlet.setTitleColor(UIColor(hexString: "B7B7B7"), for: .disabled)
            frequencyChangeLabel.text = ""
            rateView.layer.borderColor = UIColor(hexString: "504d4d")?.cgColor
            frequencyView.layer.borderColor = UIColor(hexString: "504d4d")?.cgColor
            interestRateIsVariable = true
            rateTextField.text = "0%"
            view.resignFirstResponder()
            rateValidationLabel.text = ""
        }
        validateAll()
    }
    
}

//MARK: - Textfield and Textview Delegate Methods
extension NewInvestmentViewController : UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //Delete placeholder text on input
        if descriptionTextField.text == "A short description describing this investment..." {
            descriptionTextField.text = ""
        } else {
            return
        }
    }
    
    //Delete placeholder text on input
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            textField.text = ""
            textField.textColor = UIColor(hexString: "E7E5E5")
            textField.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        case 1:
            textField.text = ""
            startValidationLabel.text = ""
            startValidationLabel.textColor = UIColor(hexString: "B7B7B7")
            raiseView()
        case 2:
            textField.text = ""
            startValidationLabel.text = ""
            startValidationLabel.textColor = UIColor(hexString: "B7B7B7")
            raiseView()
        case 3:
            textField.text = ""
            startValidationLabel.text = ""
            startValidationLabel.textColor = UIColor(hexString: "B7B7B7")
            raiseView()
        case 4:
            textField.text = ""
            raiseView()
        case 5:
            textField.text = ""
            raiseView()
        case 6:
            textField.text = ""
            raiseView()
        case 7:
            textField.text = ""
            raiseView()
            rateValidationLabel.text = ""
            rateView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
        case 8:
            textField.text = ""
            raiseView()
            textField.textColor = UIColor(hexString: "E7E5E5")
            investmentAmountView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
            amountValidationLabel.text = ""
            amountValidationLabel.textColor = UIColor(hexString: "B7B7B7")
        default: return
            
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            if validateStartDDDate() == true {
                return true
            } else {
                return false
            }
        case 2:
            if validateStartMMDate() == true {
                return true
            } else {
                return false
            }
        case 3:
            if validateStartYYDate() == true {
                return true
            } else {
                return false
            }
        case 7:
            if textField.text!.isNumeric {
                textField.text = textField.text! + "%"
                rateValidationLabel.text = ""
                validateRate()
                return true
            } else {
                textField.text = ""
                rateValidationLabel.text = "Enter valid %"
                rateValidationLabel.textColor = UIColor.flatWatermelon()
                rateView.layer.borderColor = UIColor.flatWatermelon()?.cgColor
                return true
            }
            
        case 8:
            if validateAmount() == true {
                return true
            } else {
                return true
            }
        default: return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 || textField.tag == 2 || textField.tag == 3 {
            return textField.autoMoveToNextFieldStart(textField: textField, string: string)
        } else if textField.tag == 4 || textField.tag == 5 || textField.tag == 6 {
            return textField.autoMoveToNextFieldEnd(textField: textField, string: string)
        } else if textField.tag == 7 {
            rateValidationLabel.text = ""
            rateView.layer.borderColor = UIColor(hexString: yellow)?.cgColor
            if string.isNumeric {
                textField.text = textField.text! + string
                return false
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            validateTitle()
            validateAll()
            descriptionTextField.becomeFirstResponder()
        case 1:
            validateAll()
            startMMTextField.becomeFirstResponder()
        case 2:
            validateAll()
        case 3:
            validateAll()
        default:
            textField.resignFirstResponder()
            
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0 + (self.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
                self.view.layoutIfNeeded()
            }
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateAll()
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0 + (self.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
            self.view.layoutIfNeeded()
        }
        
        switch textField.tag {
        case 0:
            validateTitle()
        case 3:
            startValidationLabel.text = ""
            startValidationLabel.textColor = UIColor(hexString: "B7B7B7")
        case 7:
            validateRate()
        default: return
        }
        validateAll()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            startDDTextField.becomeFirstResponder()
        }
        return true
    }
}

//TODO: - Validate amount text field to display currency. Fields remaining/finish button.
