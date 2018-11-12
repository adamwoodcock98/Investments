//
//  PopoverViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 08/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import RealmSwift

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var mainView: ViewWithDesignables!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ddTextField: TextFieldWithDesignables!
    @IBOutlet weak var mmTextField: TextFieldWithDesignables!
    @IBOutlet weak var yyTextField: TextFieldWithDesignables!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: TextFieldWithDesignables!
    @IBOutlet weak var cancelView: ViewWithDesignables!
    @IBOutlet weak var saveView: ViewWithDesignables!
    @IBOutlet weak var percentTextField: TextFieldWithDesignables!
    @IBOutlet weak var buttonsView: UIView!
    
    let realm = try! Realm()
    
    //Variables to be set by sending VC.
    var currentInvestmentID : String!
    var currentInvestment : Investments!
    var newEntryType : String!
    
    var selectedDD : Int = 0
    var selectedMM : Int = 0
    var selectedYY : Int = 0
    var selectedAmountOrPercent : Double = 0.0
    var ddIsValid = false
    var mmIsValid = false
    var yyIsValid = false
    var amountOrPercentIsValid = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        configure()
        configureInitialTransforms()
        amountTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let parent = self.presentingViewController
        parent?.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Functions
    
    //Configure the view for initial loading
    func configure() {
        //Remove borders from textfields
        ddTextField.borderStyle = .none
        mmTextField.borderStyle = .none
        yyTextField.borderStyle = .none
        //Set textfield delegates
        ddTextField.delegate = self
        mmTextField.delegate = self
        yyTextField.delegate = self
        amountTextField.delegate = self
        percentTextField.delegate = self
        //Set title based on sender
        titleLabel.text = "New \(newEntryType!)"
        //Format popup for percent or amount
        if newEntryType == "Withdrawal" || newEntryType == "Deposit" {
            amountTextField.isHidden = false
            percentTextField.isHidden = true
        } else if newEntryType == "Gain" {
            amountTextField.isHidden = true
            percentTextField.isHidden = false
        }
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(blurEffectView)

        view.sendSubviewToBack(blurEffectView)

    }
    
    func updateRealmGain(object: Gains, combinedObject: CombinedExtras) {
        do {
            try realm.write {
                currentInvestment.gains.append(object)
                currentInvestment.combinedExtras.append(combinedObject)
            }
        } catch {
            print("error saving object to realm")
            
            let alert = UIAlertController(title: "Error", message: "There has been an error saving your new gain, please close the app and try again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func updateRealmWithdrawal(object: Withdrawals, combinedObject: CombinedExtras) {
        do {
            try realm.write {
                currentInvestment.withdrawals.append(object)
                currentInvestment.combinedExtras.append(combinedObject)
            }
        } catch {
            print("error saving object to realm")
            
            let alert = UIAlertController(title: "Error", message: "There has been an error saving your new withdrawal, please close the app and try again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func updateRealmDeposit(object: Deposits, combinedObject: CombinedExtras) {
        do {
            try realm.write {
                currentInvestment.deposits.append(object)
                currentInvestment.combinedExtras.append(combinedObject)
            }
        } catch {
            print("error saving object to realm")
            
            let alert = UIAlertController(title: "Error", message: "There has been an error saving your new deposit, please close the app and try again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func configureInitialTransforms() {
        saveView.transform = CGAffineTransform(translationX: 414, y: 0)
        cancelView.transform = CGAffineTransform(translationX: (mainView.frame.width / 4), y: 0)
        
    }
    
    func validate() {

        if ddTextField.text!.count == 2 && ddTextField.text?.isNumeric == true {
            selectedDD = Constants.convertStringToFormattedString(input: ddTextField.text!).integerValue
            ddIsValid = true
        } else {
            ddIsValid = false
        }
        
        if mmTextField.text!.count == 2 && mmTextField.text?.isNumeric == true {
            selectedMM = Constants.convertStringToFormattedString(input: mmTextField.text!).integerValue
            mmIsValid = true
        } else {
            mmIsValid = false
        }
        
        if yyTextField.text!.count == 2 && yyTextField.text?.isNumeric == true {
            selectedYY = Constants.convertStringToFormattedString(input: yyTextField.text!).integerValue
            yyIsValid = true
        } else {
            yyIsValid = false
        }
        
        if amountTextField.isHidden == false {
            if amountTextField.text!.count >= 1 {
                amountOrPercentIsValid = true
            } else {
                amountOrPercentIsValid = false
            }
        } else {
             if percentTextField.text!.count >= 1 {
                amountOrPercentIsValid = true
            } else {
                amountOrPercentIsValid = false
            }
        }
        
        if ddIsValid == true && mmIsValid == true && yyIsValid == true && amountOrPercentIsValid == true {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                self.saveView.transform = .identity
                self.cancelView.transform = .identity
            }, completion: nil)
        } else {
            if cancelView.transform == .identity && saveView.transform == .identity {
                UIView.animate(withDuration: 0.3) {
                    self.saveView.transform = CGAffineTransform(translationX: 414, y: 0)
                    self.cancelView.transform = CGAffineTransform(translationX: (self.mainView.frame.width / 4), y: 0)
                }
            }
        }
        
    }
    
    
    //MARK : - IBActions
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let parent = self.presentingViewController
        parent?.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if newEntryType == "Gain" {
            let object = Gains()
            object.percentage = selectedAmountOrPercent
            object.timestamp = Constants.convertDDMMYYToFormattedDate(dd: selectedDD, mm: selectedMM, yy: selectedYY)
            let combinedObject = CombinedExtras()
            combinedObject.entryType = newEntryType
            combinedObject.amountOrPercent = selectedAmountOrPercent
            combinedObject.timestamp = Constants.convertDDMMYYToFormattedDate(dd: selectedDD, mm: selectedMM, yy: selectedYY)
            updateRealmGain(object: object, combinedObject: combinedObject)
        } else if newEntryType == "Withdrawal" {
            let object = Withdrawals()
            object.amount = selectedAmountOrPercent
            object.timestamp = Constants.convertDDMMYYToFormattedDate(dd: selectedDD, mm: selectedMM, yy: selectedYY)
            let combinedObject = CombinedExtras()
            combinedObject.entryType = newEntryType
            combinedObject.amountOrPercent = selectedAmountOrPercent
            combinedObject.timestamp = Constants.convertDDMMYYToFormattedDate(dd: selectedDD, mm: selectedMM, yy: selectedYY)
            updateRealmWithdrawal(object: object, combinedObject: combinedObject)
        } else if newEntryType == "Deposit" {
            let object = Deposits()
            object.amount = selectedAmountOrPercent
            object.timestamp = Constants.convertDDMMYYToFormattedDate(dd: selectedDD, mm: selectedMM, yy: selectedYY)
            let combinedObject = CombinedExtras()
            combinedObject.entryType = newEntryType
            combinedObject.amountOrPercent = selectedAmountOrPercent
            combinedObject.timestamp = Constants.convertDDMMYYToFormattedDate(dd: selectedDD, mm: selectedMM, yy: selectedYY)
            updateRealmDeposit(object: object, combinedObject: combinedObject)
        }
        
        let parent = self.presentingViewController
        parent?.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
   
}

extension PopoverViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        validate()
    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        validate()
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
        
        if amountOrPercentIsValid == true && textField.tag == 0 {
            let text = amountTextField.text!
            amountTextField.text = Constants.convertStringToFormattedString(input: text).stringValue
            selectedAmountOrPercent = Constants.convertStringToFormattedString(input: text).doubleValue
            print("This is the selected amount: \(selectedAmountOrPercent)")
        } else if amountOrPercentIsValid == true && textField.tag == 7 {
            let text = percentTextField.text!
            percentTextField.text = "\(text)%"
            selectedAmountOrPercent = Constants.convertStringToFormattedString(input: text).doubleValue
            print("This is the selected amount: \(selectedAmountOrPercent)")
        }
        validate()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 || textField.tag == 2 || textField.tag == 3 {
            return textField.autoMoveToNextFieldStart(textField: textField, string: string)
        }
        
        return true
    }
}
//        UIView.animate(withDuration: 0.8, delay: 3, options: [], animations: {
//            self.saveView.transform = .identity
//            self.cancelView.transform = .identity
//        }, completion: nil)

//        UIView.animate(withDuration: 0.8, delay: 3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
//            self.saveView.transform = .identity
//            self.cancelView.transform = .identity
//        }, completion: nil)
