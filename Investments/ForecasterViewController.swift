//
//  ViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 05/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit

class ForecasterViewController: UIViewController {
    
    @IBOutlet weak var investmentAmountTextField: UITextField!
    @IBOutlet weak var withdrawalAmountTextField: UITextField!
    @IBOutlet weak var percentSwitch: UISwitch!
    @IBOutlet weak var manualPercentLabel: UILabel!
    @IBOutlet weak var percentSlider: UISlider!
    @IBOutlet weak var investmentDurationButton: UIButton!
    @IBOutlet weak var investmentDurationButtonLabel: UILabel!
    @IBOutlet weak var withdrawalDurationButton: UIButton!
    @IBOutlet weak var withdrawalDurationButtonLabel: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var autoPercentLabel: UILabel!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    
    var sliderValue: Float = 0.0
    var whichInvestmentPicker : [Int] = []
    var whichWithdrawalPicker : [Int] = []
    var pickedInvestmentNumber : Int = 0
    var pickedWithdrawalNumber : Int = 0
    var pickedPercentage : Float = 0.0
    var autoPercent : Float = 8.32
    var pickedInvestmentAmount : Int = 0
    var pickedWithdrawalAmount : Int = 0
    
    var investmentLabelNumber : String = ""
    var investmentLabelDate : String = ""
    var withdrawalLabelNumber : String = ""
    var withdrawalLabelDate : String = ""
    
    //Defining picker constants to access them as if they were IBOutlets
    let picker1 = UIPickerView()
    let picker2 = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TextField Adjustments
        investmentAmountTextField.borderStyle = .none
        withdrawalAmountTextField.borderStyle = .none
        investmentAmountTextField.delegate = self
        withdrawalAmountTextField.delegate = self
        autoPercentLabel.text = "\(autoPercent)%" //FIXME: Add the variable for auto-calculated growth when available
        
        //Hide/State Adjustments
        percentSlider.isHidden = true
        investmentDurationButtonLabel.isHidden = true
        withdrawalDurationButtonLabel.isHidden = true
        percentSwitch.setOn(true, animated: true)
        nextBarButton.isEnabled = false
        
        //Setting the default picker values
        whichInvestmentPicker = Constants.pickerWeeksNumbers
        whichWithdrawalPicker = Constants.pickerWeeksNumbers
        
        //Enabling custom method
        self.hideKeyboardWhenTappedAround()
    
        validateCompletionAndEnableNextButton()
    }
    
    //MARK: - IBActions
    @IBAction func percentSwitch(_ sender: Any) {
        
        if percentSwitch.isOn {
            manualPercentLabel.text = "Auto %"
            percentSlider.isHidden = true
            autoPercentLabel.isHidden = false
        } else {
            manualPercentLabel.text = "Manual %"
            percentSlider.isHidden = false
            percentSlider.setValue(percentSlider.maximumValue / 2, animated: true)
            autoPercentLabel.isHidden = true
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        sliderValue = percentSlider.value.rounded()
        manualPercentLabel.text = "\(sliderValue)%"
    }
    
    @IBAction func nextTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    //Hiding button, w/o disablind and changing text from placeholder colour to accent yellow
    @IBAction func investmentPickerTapped(_ sender: Any) {
        showPickerInActionSheet(sentBy: "Investments")
        investmentDurationButtonLabel.isHidden = false
        investmentDurationButtonLabel.textColor = UIColor(hexString: "f5b316")
        investmentDurationButton.setTitleColor(UIColor.darkGray, for: .normal)
        investmentDurationButton.setTitleColor(UIColor.darkGray, for: .selected)
        investmentDurationButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        investmentDurationButtonLabel.text = "\(investmentLabelNumber) \(investmentLabelDate)"
    }
    
    //Hiding button, w/o disablind and changing text from placeholder colour to accent yellow
    @IBAction func withdrawalPickerTapped(_ sender: Any) {
        showPickerInActionSheet(sentBy: "Withdrawals")
        withdrawalDurationButtonLabel.isHidden = false
        withdrawalDurationButtonLabel.textColor = UIColor(hexString: "f5b316")
        withdrawalDurationButton.setTitleColor(UIColor.darkGray, for: .normal)
        withdrawalDurationButton.setTitleColor(UIColor.darkGray, for: .selected)
        withdrawalDurationButton.setTitleColor(UIColor.darkGray, for: .highlighted)
        withdrawalDurationButtonLabel.text = "\(withdrawalLabelNumber) \(withdrawalLabelDate)"
    }
    
    //MARK: Functions
    
    //Function to validate that all fields are complete and enable the next button
    func validateCompletionAndEnableNextButton() {
        //Defining booleans to confirm validation
        var investmentAmount = false
        var withdrawalAmount = false
        var pickedInvestment = false
        var pickedWithdrawal = false
        var percentValue = false
        
        if investmentAmountTextField.text != "" {
            print("investment amount NOT nil")
            investmentAmount = true
        } else {
            print("investment amount IS nil")
            investmentAmount = false
        }
        
        if withdrawalAmountTextField.text != "" {
            print("withdrawal amount NOT nil")
            withdrawalAmount = true
        } else {
            print("withdrawal amount IS nil")
            withdrawalAmount = false
        }
        
        if pickedInvestmentNumber > 0 {
            print("picked investment number NOT nil")
            pickedInvestment = true
        } else {
            print("picked investment number IS nil")
            pickedInvestment = false
        }
        
        if pickedWithdrawalNumber > 0 {
            print("picked withdrawal number NOT nil")
            pickedWithdrawal = true
        } else {
            print("picked withdrawal number IS nil")
            pickedWithdrawal = false
        }
        
        if sliderValue > 0 && percentSwitch.isOn == false || autoPercentLabel.text != nil && percentSwitch.isOn == true {
            print("growth % NOT nil")
            percentValue = true
            if percentSwitch.isOn == true {
                pickedPercentage = autoPercent
            } else {
                pickedPercentage = sliderValue
            }
        } else {
            print("growth % IS nil")
            percentValue = false
        }
        
        if investmentAmount == true && withdrawalAmount == true && pickedInvestment == true && pickedWithdrawal == true && percentValue == true {
            nextBarButton.isEnabled = true
        } else {
            return
        }
    }

    //MARK: Segue Preparations
    
    //Preparing for segue to results and setting all the required values
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destinationVC = segue.destination as! ResultsViewController
            
            destinationVC.investmentAmount = pickedInvestmentAmount
            destinationVC.withdrawalAmount = pickedWithdrawalAmount
            destinationVC.growth = pickedPercentage
            destinationVC.investmentDurationNumber = pickedInvestmentNumber
            destinationVC.withdrawalDurationNumber = pickedWithdrawalNumber
            destinationVC.investmentDurationDate = investmentLabelDate
            destinationVC.withdrawalDurationDate = withdrawalLabelDate
        }
    }
}

//MARK: - PickerView Methods
extension ForecasterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    //Creating an action for the custom 'Done' button in the picker action sheet
    @objc func okay(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showPickerInActionSheet(sentBy: String) {
        //Creating alert object and width constants
        let alert = UIAlertController(title: "", message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let alertWidth = alert.view.bounds.size.width
        
        //Creating pickers frames and objects, left:
        let picker1Frame : CGRect = CGRect(x: 0, y: 2, width: (alertWidth / 2) - 4, height: 100)
        picker1.frame = picker1Frame
        //right:
        let picker2Frame : CGRect = CGRect(x: (alertWidth / 2) + 2, y: 2, width: (alertWidth / 2) - 4, height: 100)
        picker2.frame = picker2Frame
        
        //Assigning delegates and data sources for pickers
        picker1.delegate = self
        picker1.dataSource = self
        picker2.delegate = self
        picker2.dataSource = self
        
        //Adding pickers to the alert view
        alert.view.addSubview(picker1)
        alert.view.addSubview(picker2)
        alert.view.clipsToBounds = true
        
        //Creating and configuring the 'Done' button
        let buttonFrame : CGRect = CGRect(x: 0, y: 104, width: alertWidth - 10, height: 50)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor(hexString: "e7e5e5"), for: .normal)
        button.addTarget(self, action: #selector(okay), for: .touchUpInside)
        button.backgroundRect(forBounds: CGRect(x: 0, y: 104, width: alertWidth, height: 50))
        button.backgroundColor = UIColor(hexString: "f5b316")
        button.layer.bounds = CGRect(x: 0, y: 104, width: alertWidth - 30, height: 50)
        button.layer.cornerRadius = 15
        
        
        //Adding the button to the view
        alert.view.addSubview(button)
        
        //Assigning tags to each picker based on the field that sent the user there
        if sentBy == "Investments" {
            picker1.tag = 3
            picker2.tag = 4
        } else if sentBy == "Withdrawals" {
            picker1.tag = 5
            picker2.tag = 6
        }
        
        //Setting default values
        investmentLabelDate = "Weeks"
        investmentLabelNumber = "1"
        pickedInvestmentNumber = 1
        withdrawalLabelDate = "Weeks"
        withdrawalLabelNumber = "1"
        pickedWithdrawalNumber = 1
        
        //Validation
        validateCompletionAndEnableNextButton()
        
        //Finally, presenting the alert to the user
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 3: return whichInvestmentPicker.count
        case 4: return Constants.pickerComponent2.count
        case 5: return whichWithdrawalPicker.count
        case 6: return Constants.pickerComponent2.count
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerView.tag {
        case 3: return NSAttributedString(string: "\(whichInvestmentPicker[row])", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hexString: "504d4d")])
        case 4: return NSAttributedString(string: "\(Constants.pickerComponent2[row])", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hexString: "504d4d")])
        case 5: return NSAttributedString(string: "\(whichWithdrawalPicker[row])", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hexString: "504d4d")])
        case 6: return NSAttributedString(string: "\(Constants.pickerComponent2[row])", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hexString: "504d4d")])
        default: return NSAttributedString(string: "--\(print(" Undefined/unrecognised picker tag for title"))")
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 3:
            investmentLabelNumber = String(whichInvestmentPicker[row])
            pickedInvestmentNumber = whichInvestmentPicker[row]
        case 4://Changing the numbers in the left picker depening on whether the user selects weeks or months
            if Constants.pickerComponent2[row] == "Weeks" {
                whichInvestmentPicker = Constants.pickerWeeksNumbers
                pickerView.reloadAllComponents()
                picker1.reloadAllComponents()
                picker1.selectRow(0, inComponent: 0, animated: true)
                investmentLabelNumber = "1"
                pickedInvestmentNumber = 1
                investmentLabelDate = "Weeks"
            } else {
                whichInvestmentPicker = Constants.pickerMonthsNumbers
                pickerView.reloadAllComponents()
                picker1.reloadAllComponents()
                picker1.selectRow(0, inComponent: 0, animated: true)
                investmentLabelNumber = "1"
                pickedInvestmentNumber = 1
                investmentLabelDate = "Months"
            }
        case 5:
            withdrawalLabelNumber = String(whichWithdrawalPicker[row])
            pickedWithdrawalNumber = whichWithdrawalPicker[row]
        case 6:
            if Constants.pickerComponent2[row] == "Weeks" {
                whichWithdrawalPicker = Constants.pickerWeeksNumbers
                pickerView.reloadAllComponents()
                picker1.reloadAllComponents()
                picker1.selectRow(0, inComponent: 0, animated: true)
                withdrawalLabelNumber = "1"
                pickedWithdrawalNumber = 1
                withdrawalLabelDate = "Weeks"
            } else {
                whichWithdrawalPicker = Constants.pickerMonthsNumbers
                pickerView.reloadAllComponents()
                picker1.reloadAllComponents()
                picker1.selectRow(0, inComponent: 0, animated: true)
                withdrawalLabelNumber = "1"
                pickedWithdrawalNumber = 1
                withdrawalLabelDate = "Months"
            }
        default: print("Undefined/unrecognised picker tag for row select")
        }
        //Setting label text to display choices
        investmentDurationButtonLabel.text = "\(investmentLabelNumber) \(investmentLabelDate)"
        withdrawalDurationButtonLabel.text = "\(withdrawalLabelNumber) \(withdrawalLabelDate)"
        
        //Validation
        validateCompletionAndEnableNextButton()
    }
    
    
}

//MARK: - TextField Delegate Methods
extension ForecasterViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.clearsOnInsertion = true
        textField.returnKeyType = .next
        
        return true
    }
    
    //Using this function to format the TextFields into currency
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        //Validation
        validateCompletionAndEnableNextButton()
        
        //If TextFields are not empty then validate the amounts
        if textField == investmentAmountTextField {
            if let text = investmentAmountTextField.text {
                textField.text = Constants.convertStringToFormattedString(input: text).stringValue
                pickedInvestmentNumber = Constants.convertStringToFormattedString(input: text).integerValue
                
                return true
            } else {
                textField.text = "Enter"
                return true
            }
            
        } else if textField == withdrawalAmountTextField {
            if let text = withdrawalAmountTextField.text {
                textField.text = Constants.convertStringToFormattedString(input: text).stringValue
                pickedWithdrawalNumber = Constants.convertStringToFormattedString(input: text).integerValue
                
                return true
            } else {
                textField.text = "Enter"
                return true
            }
        }
        
        return true
    }
}
