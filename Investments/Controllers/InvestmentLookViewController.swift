//
//  InvestmentLookViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 02/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class InvestmentLookViewController: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var descriptionTextFIeld: UITextView!
    @IBOutlet weak var chartBackground: UILabel!
    @IBOutlet weak var investmentValueView: UIView!
    @IBOutlet weak var percentChangeView: UIView!
    @IBOutlet weak var investmentValueLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var totalInvestedView: UIView!
    @IBOutlet weak var mostRecentGainView: UIView!
    @IBOutlet weak var totalInvestedLabel: UILabel!
    @IBOutlet weak var totalInvestedTitleLabel: UILabel!
    @IBOutlet weak var mostRecentGainPercentLabel: UILabel!
    @IBOutlet weak var mostRecentGainDateLabel: UILabel!
    @IBOutlet weak var multiView: UIView!
    @IBOutlet weak var miniTableView: UITableView!
    @IBOutlet weak var FAB: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bigCircleBackgroundView: UIView!
    @IBOutlet weak var piggyPlusOutlet: UIButton!
    @IBOutlet weak var piggyMinusOutlet: UIButton!
    @IBOutlet weak var piggyGrowthOutlet: UIButton!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var initialInvestmentTextField: UITextField!
    
    let realm = try! Realm()
    let yellow = UIColor(hexString: "F5B316")
    
    var notificationGains : NotificationToken? = nil
    var notificationWithdrawals : NotificationToken? = nil
    var notificationDeposits : NotificationToken? = nil
    var currentInvestment : Investments!
    var currentInvestmentGains : Results<Gains>!
    var currentInvestmentWithdrawals : Results<Withdrawals>!
    var currentInvestmentDeposits : Results<Deposits>!
    var currentInvestmentCombinedExtras : Results<CombinedExtras>?
    var investmentID : String!
    var totalInvested : Double!
    var mostRecentGainObject : Gains!
    var popoverSender : String = ""
    var gainsDictionary : [Double : Date] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRealm()
        configureArithmetic()
        configureUI()
        listenForNotifications()
    }
    
    //MARK: - Functions
    
    //Configure the Realm database to retrieve investment object.
    func configureRealm() {
        
        //Assigning the currentInvestment variable the realm object associated with the investment ID passed in.
        currentInvestment = realm.object(ofType: Investments.self, forPrimaryKey: investmentID)
        
        //Assigning the currentInvestmentGains variables with gains matching this investment
        currentInvestmentGains = currentInvestment.gains.sorted(byKeyPath: "timestamp", ascending: true)
        
        //Assigning the currentInvestmentWithdrawals with withdrawals matching this investment
        currentInvestmentWithdrawals = currentInvestment.withdrawals.sorted(byKeyPath: "timestamp", ascending: true)
        
        //Assigning the currentInvestmentDeposits with deposits matching this investment
        currentInvestmentDeposits = currentInvestment.deposits.sorted(byKeyPath: "timestamp", ascending: true)
        
        //Set navigation bar back button title
        navigationItem.hidesBackButton = false
    }
    
    //Configure arithmetic to load into the display
    func configureArithmetic() {
        //Calculate running total
        //Calculate total invested
        calculateTotalInvested()
        //Calculate most recent gain
        let gain = Gains(); gain.percentage = 9.8; gain.timestamp = Date()
        mostRecentGainObject = gain
        
        
    }
    
    func calculateTotalInvested() {
        var totalDeposits : Double = 0.0
        for entry in currentInvestmentDeposits {
            totalDeposits += entry.amount
        }
        totalInvested = totalDeposits + currentInvestment.initialInvestment
        totalInvestedLabel.text = Constants.convertStringToFormattedString(input: "\(totalInvested!)").stringValue
    }
    
    func calculateInvestmentValue() {
        
    }
    
    func combineRealmRelationshipDatabases() {
        
    }
    
    //Calculate gains
    
    //Configure the UI to display correct values, and design elements.
    func configureUI() {
        //Dismiss keyboard when tapped around
        hideKeyboardWhenTappedAround()
        //Configure title
        self.title = currentInvestment.title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : yellow!, NSAttributedString.Key.font : UIFont(name: "SourceSansPro-SemiBold", size: 25)!]
        //Configure description
        descriptionTextFIeld.delegate = self
        descriptionTextFIeld.text = currentInvestment.investmentDescription ?? ""
        descriptionTextFIeld.layer.borderWidth = 0
        descriptionTextFIeld.layer.borderColor = yellow?.cgColor
        descriptionTextFIeld.layer.cornerRadius = 8
        descriptionTextFIeld.isEditable = false
        descriptionTextFIeld.isSelectable = false
        if descriptionTextFIeld.text == "" || descriptionTextFIeld.text == nil {
            descriptionTextFIeld.text = "Tap the edit button in the top right to add a description"
            descriptionTextFIeld.textColor = UIColor.darkGray.lighten(byPercentage: 0.1)
        }
        //Configure chart
        view2.layer.cornerRadius = 8
        view2.layer.borderWidth = 2
        view2.layer.borderColor = UIColor.lightGray.cgColor
        //Configure investment value
        investmentValueView.layer.borderWidth = 0
        investmentValueView.layer.borderColor = yellow?.cgColor
        investmentValueView.layer.cornerRadius = 8
        investmentValueLabel.text = Constants.convertStringToFormattedString(input: "\(currentInvestment.runningTotal)").stringValue
        //Configure % change
        percentChangeView.layer.borderWidth = 0
        percentChangeView.layer.borderColor = yellow?.cgColor
        percentChangeView.layer.cornerRadius = 8
        let percentChange = (((currentInvestment.runningTotal - currentInvestment.initialInvestment) / currentInvestment.initialInvestment) * 100).rounded2DecimalPlaces
        percentChangeLabel.text = "\(percentChange)%"
        //Configure total investment
        totalInvestedView.layer.borderWidth = 0
        totalInvestedView.layer.borderColor = yellow?.cgColor
        totalInvestedView.layer.cornerRadius = 8
        totalInvestedLabel.text = Constants.convertStringToFormattedString(input: "\(totalInvested!)").stringValue
        //Configure most recent gain
        mostRecentGainView.layer.borderWidth = 0
        mostRecentGainView.layer.borderColor = yellow?.cgColor
        mostRecentGainView.layer.cornerRadius = 8
        mostRecentGainPercentLabel.text = Constants.convertStringToFormattedString(input: "\(currentInvestment.initialInvestment)").stringValue
        let initialInvestmentDate = Constants.convertDDMMYYToFormattedDate(dd: currentInvestment.dayStarted, mm: currentInvestment.monthStarted, yy: currentInvestment.yearStarted)
        let initialInvestmentDateString = Constants.formatDateToLongDate(date: initialInvestmentDate)
        mostRecentGainDateLabel.text = initialInvestmentDateString
        //Configure final section
        multiView.layer.borderColor = yellow?.cgColor
        multiView.layer.borderWidth = 0
        multiView.layer.cornerRadius = 8
        //Configure FAB
        FAB.layer.cornerRadius = FAB.frame.width / 2
        //Configure table view
        miniTableView.separatorStyle = .none
        miniTableView.delegate = self
        miniTableView.dataSource = self
        let cellNibGains = UINib(nibName: "GainsCell", bundle: nil)
        miniTableView.register(cellNibGains, forCellReuseIdentifier: "gains")
        let cellNibWD = UINib(nibName: "WithdrawalDepositsCell", bundle: nil)
        miniTableView.register(cellNibWD, forCellReuseIdentifier: "normal")
        //Configure FAB expand background
        bigCircleBackgroundView.layer.cornerRadius = 375 / 2
        bigCircleBackgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        bigCircleBackgroundView.layer.shadowColor = UIColor.black.cgColor
        bigCircleBackgroundView.layer.shadowOpacity = 0.3
        bigCircleBackgroundView.layer.shadowOffset = CGSize.zero
        bigCircleBackgroundView.layer.shadowRadius = 20
        bigCircleBackgroundView.isUserInteractionEnabled = false
        piggyMinusOutlet.transform = CGAffineTransform(translationX: -10, y: -10)
        piggyPlusOutlet.transform = CGAffineTransform(translationX: -10, y: -10)
        piggyGrowthOutlet.transform = CGAffineTransform(translationX: -10, y: -10)
        //Configure initial investment text field
        initialInvestmentTextField.borderStyle = .none
        initialInvestmentTextField.isHidden = true
        initialInvestmentTextField.text = Constants.convertStringToFormattedString(input: "\(currentInvestment.initialInvestment)").stringValue
    }
    
    func listenForNotifications() {
        notificationGains = currentInvestmentGains.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self.configureArithmetic()
                self.miniTableView.reloadData()
            case .initial:
                self.configureArithmetic()
                self.miniTableView.reloadData()
            case .error:
                print("error")
            }
        })
        
        notificationWithdrawals = currentInvestmentWithdrawals.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self.configureArithmetic()
                self.miniTableView.reloadData()
            case .initial:
                self.configureArithmetic()
                self.miniTableView.reloadData()
            case .error:
                print("error")
            }
        })
        
        notificationDeposits = currentInvestmentDeposits.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self.configureArithmetic()
                self.miniTableView.reloadData()
            case .initial:
                self.configureArithmetic()
                self.miniTableView.reloadData()
            case .error:
                print("error")
            }
        })
    }
    
    func closeFAB() {
        self.bigCircleBackgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.piggyMinusOutlet.transform = CGAffineTransform(translationX: -10, y: 0)
        self.piggyPlusOutlet.transform = CGAffineTransform(translationX: 0, y: -10)
        self.piggyGrowthOutlet.transform = CGAffineTransform(translationX: -8, y: -8)
    }
    
    func showPopover(sender: String) {
        popoverSender = sender
        performSegue(withIdentifier: "goToPopover", sender: self)
    }
    
    //MARK: Realm Functions
    
    //Update object and present alert if fails
    func updateRealm(investmentObject: Object) {
        do {
            try realm.write {
                realm.add(investmentObject, update: true)
            }
        } catch {
            print(error)
            let alert = UIAlertController(title: "Error", message: "There has been an error saving the new information, please close the app and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    func deleteRealm(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            let alert = UIAlertController(title: "Error", message: "There has been an error deleting this item, please close the app and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Segue Preparations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPopover" {
            let destination = segue.destination as! PopoverViewController
            destination.currentInvestmentID = investmentID
            destination.currentInvestment = currentInvestment
            destination.newEntryType = "\(popoverSender)"
        }
    }
    
    //MARK: IBActions
    @IBAction func segmentedControlChanged(_ sender: Any) {
        miniTableView.reloadData()
    }
    
    @IBAction func fabTapped(_ sender: FloatingActionButton) {
        UIView.animate(withDuration: 0.3) {
            if self.bigCircleBackgroundView.transform == .identity {
                self.closeFAB()
                self.bigCircleBackgroundView.isUserInteractionEnabled = false
                
            } else {
                self.bigCircleBackgroundView.transform = .identity
                self.bigCircleBackgroundView.isUserInteractionEnabled = true
            }
        }
        
        if self.bigCircleBackgroundView.transform == .identity {
            UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [.allowUserInteraction], animations: {
                self.piggyMinusOutlet.transform = .identity
                self.piggyPlusOutlet.transform = .identity
                self.piggyGrowthOutlet.transform = .identity
            }, completion: nil)
        }
        
    }
    
    @IBAction func editTapped(_ sender: Any) {
        if editButtonOutlet.title == "Edit" {
            editButtonOutlet.title = "Done"
            descriptionTextFIeld.isSelectable = true
            descriptionTextFIeld.isHidden = false
            descriptionTextFIeld.isEditable = true
            descriptionTextFIeld.layer.borderWidth = 2
        } else if editButtonOutlet.title == "Done" {
            var newDescription : String? = nil
            editButtonOutlet.title = "Edit"
            descriptionTextFIeld.isSelectable = false
            descriptionTextFIeld.isHidden = false
            descriptionTextFIeld.isEditable = false
            if descriptionTextFIeld.text == "" || descriptionTextFIeld.text == nil || descriptionTextFIeld.text == "Tap the edit button in the top right to add a description" {
                newDescription = ""
                descriptionTextFIeld.text = "Tap the edit button in the top right to add a description"
                descriptionTextFIeld.textColor = UIColor.darkGray.lighten(byPercentage: 0.1)
            } else {
                newDescription = descriptionTextFIeld.text
                descriptionTextFIeld.textColor = UIColor(hexString: "E7E5E5")
            }
            descriptionTextFIeld.layer.borderWidth = 0

            do {
                if newDescription != nil {
                    try realm.write {
                        currentInvestment.investmentDescription = newDescription
                        realm.add(currentInvestment, update: true)
                    }
                }
            } catch {
                let alert = UIAlertController(title: "Error", message: "There has been an error updating this information, please close the app and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        }

    }
    
    @IBAction func plusPiggyTapped(_ sender: Any) {
        showPopover(sender: "Deposit")
    }
    
    @IBAction func growthPiggyTapped(_ sender: Any) {
        showPopover(sender: "Gain")
    }
    
    @IBAction func minusPiggyTapped(_ sender: Any) {
        showPopover(sender: "Withdrawal")
    }
    

}



//MARK: - TableView Extension
extension InvestmentLookViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    //Assigning the cell based on the segmented control
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //Dequeueing the cell for gains
            let cell = tableView.dequeueReusableCell(withIdentifier: "gains", for: indexPath) as! GainsCell
            //Setting the delegate
            cell.delegate = self
            //Current row
            let currentRow = currentInvestmentGains[indexPath.row]
            //Assigning the cell properties
            cell.title.text = Constants.convertStringToFormattedString(input: String(currentRow.difference)).stringValue
            cell.date.text = Constants.formatDateToLongDate(date: currentRow.timestamp!)
            cell.percentage.text = "\(currentRow.percentage)%"

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! WithdrawalDepositsCell
            cell.delegate = self
            let currentRow = currentInvestmentWithdrawals[indexPath.row]
            let convertedAmount = "\(currentRow.amount)"
            cell.title.text = Constants.convertStringToFormattedString(input: convertedAmount).stringValue
            cell.date.text = Constants.formatDateToLongDate(date: currentRow.timestamp!)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! WithdrawalDepositsCell
            cell.delegate = self
            let currentRow = currentInvestmentDeposits[indexPath.row]
            cell.title.text = Constants.convertStringToFormattedString(input: String(currentRow.amount)).stringValue
            cell.date.text = Constants.formatDateToLongDate(date: currentRow.timestamp!)

            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! WithdrawalDepositsCell
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Counting the appropriate number of entries
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return currentInvestmentGains.count
        case 1:
            return currentInvestmentWithdrawals.count
        case 2:
            return currentInvestmentDeposits.count
        default:
            return 0
        }
    }
    
    //Creating swipe actions for the cells
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            //Only return an action if the swipe is from the right
            guard orientation == .right else {return nil}
            //Creating and configuring an action then deleting the object from the Realm.
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                let cellToDelete = self.currentInvestmentGains[indexPath.row]
                self.deleteRealm(object: cellToDelete)
            }
            //Assigning a trash bin icon
            deleteAction.image = UIImage(named: "delete")
            //Returning the action
            return [deleteAction]
            
        case 1:
            guard orientation == .right else {return nil}
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                let cellToDelete = self.currentInvestmentWithdrawals[indexPath.row]
                self.deleteRealm(object: cellToDelete)
            }
            
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
            
        case 2:
            guard orientation == .right else {return nil}
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                let cellToDelete = self.currentInvestmentDeposits[indexPath.row]
                self.deleteRealm(object: cellToDelete)
            }
            
            deleteAction.image = UIImage(named: "delete")
            
            return [deleteAction]
            
        default:
            return nil
        }

    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
}

//MARK : - TextView Delegate Methods
extension InvestmentLookViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor(hexString: "E7E5E5")
    }
}
