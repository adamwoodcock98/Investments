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
import Charts

class InvestmentLookViewController: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var descriptionTextFIeld: UITextView!
    @IBOutlet weak var chartView: LineChartView!
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
    
    
    weak var axisFormatDelegate : IAxisValueFormatter?
    
    let realm = try! Realm()
    let yellow = UIColor(hexString: "F5B316")
    
    var notificationGains : NotificationToken? = nil
    var notificationWithdrawals : NotificationToken? = nil
    var notificationDeposits : NotificationToken? = nil
    var currentInvestment : Investments!
    var currentInvestmentGains : Results<Gains>!
    var currentInvestmentWithdrawals : Results<Withdrawals>!
    var currentInvestmentDeposits : Results<Deposits>!
    var currentInvestmentCombinedExtras : Results<CombinedExtras>!
    var investmentID : String!
    var totalInvested : Double!
    var mostRecentGainObject : Gains!
    var popoverSender : String = ""
    var gainsDictionary : [Double : Date] = [:]
    var growthDifferences : [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        
        configureRealm()
        configureArithmetic()
        configureUI()
        listenForNotifications()
    }
    
    //MARK: - Functions
    
    //Configure arithmetic to load into the display
    func configureArithmetic() {
        //Calculate running total
        calculateInvestmentValue()
        //Calculate total invested
        calculateTotalInvested()
        //Calculate change
        calculateChange()
        //Update chart
        updateChartWithData()
        
        
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
        investmentValueLabel.text = Constants.convertStringToFormattedString(input: "\(currentInvestment.initialInvestment)").stringValue
        
        var runningTotal : Double = currentInvestment.initialInvestment
        
        for entry in currentInvestmentCombinedExtras {
            if entry.entryType == "Gain" {
                let gDifference = (runningTotal * (1 + (entry.amountOrPercent / 100))) - runningTotal
                growthDifferences.append(gDifference)
                runningTotal = runningTotal * (1 + (entry.amountOrPercent / 100))
            }
            
            if entry.entryType == "Withdrawal" {
                runningTotal = runningTotal - entry.amountOrPercent
            }
            
            if entry.entryType == "Deposit" {
                runningTotal = runningTotal + entry.amountOrPercent
            }
        }
        runningTotal = runningTotal.rounded2DecimalPlaces
        investmentValueLabel.text = Constants.convertStringToFormattedString(input: "\(runningTotal)").stringValue
        
        do {
            try realm.write {
                currentInvestment.runningTotal = runningTotal
                realm.add(currentInvestment, update: true)
            }
        } catch {
            print(error)
            print(error)
            let alert = UIAlertController(title: "Error", message: "There has been an internal error, please close the app and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func calculateChange() {
        var depositTotals = 0.0
        for entry in currentInvestmentDeposits {
            depositTotals += entry.amount
        }
        let increaseOrDecrease = (((currentInvestment.runningTotal - (currentInvestment.initialInvestment + depositTotals)) / (currentInvestment.initialInvestment + depositTotals)) * 100).rounded2DecimalPlaces
        
        percentChangeLabel.text = "\(increaseOrDecrease)%"
        
        do {
            try realm.write {
                currentInvestment.mostRecentGain = increaseOrDecrease.rounded2DecimalPlaces
            }
        } catch {
            print(error)
        }
    }
    
    
    
    
    
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
            let difference = growthDifferences[indexPath.row].rounded2DecimalPlaces
            cell.title.text = Constants.convertStringToFormattedString(input: String(difference)).stringValue
            cell.date.text = Constants.formatDateToLongDate(date: currentRow.timestamp!)
            cell.percentage.text = "\(currentRow.percentage.rounded2DecimalPlaces)%"

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
            //deleteAction.image = UIImage(named: "trashIcon")
            deleteAction.font = UIFont(name: "SourceSansPro-SemiBold", size: 20)
            //Returning the action
            return [deleteAction]
            
        case 1:
            guard orientation == .right else {return nil}
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                let cellToDelete = self.currentInvestmentWithdrawals[indexPath.row]
                self.deleteRealm(object: cellToDelete)
            }
            
            //deleteAction.image = UIImage(named: "trashIcon")
            deleteAction.font = UIFont(name: "SourceSansPro-SemiBold", size: 20)
            
            return [deleteAction]
            
        case 2:
            guard orientation == .right else {return nil}
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                let cellToDelete = self.currentInvestmentDeposits[indexPath.row]
                self.deleteRealm(object: cellToDelete)
            }
            
            //deleteAction.image = UIImage(named: "trashIcon")
            deleteAction.font = UIFont(name: "SourceSansPro-SemiBold", size: 20)
            
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

//MARK: - TextView Delegate Methods
extension InvestmentLookViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor(hexString: "E7E5E5")
    }
}

//MARK: - Axis Delegate Methods
extension InvestmentLookViewController : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

//MARK: - Extension for chart functions
extension InvestmentLookViewController {
    
    func updateChartWithData() {
        var gainDataEntries = [ChartDataEntry]()
        for (_ , element) in currentInvestmentGains.enumerated() {
            let timeInterval : TimeInterval = element.timestamp.timeIntervalSince1970
            
            let dataEntry = ChartDataEntry(x: Double(timeInterval), y: element.percentage)
            
            gainDataEntries.append(dataEntry)
        }
        
        let line1 = LineChartDataSet(values: gainDataEntries, label: "Gains")
        line1.colors = [yellow!]
        line1.circleColors = [yellow!]
        line1.circleHoleColor = yellow!
        line1.circleRadius = 5
        line1.valueTextColor = UIColor(hexString: "B7B7B7")
        line1.valueFont = UIFont(descriptor: UIFontDescriptor(name: "SourceSansPro-SemiBold", size: 12), size: 12)
        
        
        
        
        let data1 = LineChartData()
        data1.addDataSet(line1)
        
        chartView.data = data1
        chartView.chartDescription?.text = ""
        chartView.drawGridBackgroundEnabled = false
        
        
        chartView.backgroundColor = UIColor.darkGray
        chartView.rightAxis.enabled = false
        chartView.pinchZoomEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelTextColor = UIColor(hexString: "B7B7B7")
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(descriptor: UIFontDescriptor(name: "SourceSansPro-SemiBold", size: 10), size: 10)
        xAxis.xOffset = 0
        xAxis.axisLineColor = yellow!
        xAxis.axisLineWidth = 1
        xAxis.spaceMin = 10
        xAxis.spaceMax = 10
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineDashLengths = [CGFloat(4)]
        xAxis.drawAxisLineEnabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelPosition = .outsideChart
        yAxis.labelTextColor = UIColor(hexString: "B7B7B7")
        yAxis.labelFont = UIFont(descriptor: UIFontDescriptor(name: "SourceSansPro-SemiBold", size: 14), size: 14)
        yAxis.axisLineColor = yellow!
        yAxis.axisLineWidth = 1
        yAxis.spaceMin = 10
        yAxis.spaceMax = 10
        yAxis.drawGridLinesEnabled = true
        yAxis.drawAxisLineEnabled = false
        yAxis.gridLineDashLengths = [CGFloat(4)]
        yAxis.xOffset = 10
        
        
        let legend = chartView.legend
        legend.enabled = false
        legend.xEntrySpace = 0
        legend.yEntrySpace = 0
        legend.textColor = UIColor(hexString: "B7B7B7")
        legend.font = UIFont(descriptor: UIFontDescriptor(name: "SourceSansPro-Light", size: 14), size: 14)
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        
        
    }
}

//MARK: - Extension for Realm Functions
extension InvestmentLookViewController {
    
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
        
        //Assigning the currentInvestmentCombinedObjects with combined objects matching this investment
        currentInvestmentCombinedExtras = currentInvestment.combinedExtras.sorted(byKeyPath: "timestamp", ascending: true)
        
        //Set navigation bar back button title
        navigationItem.hidesBackButton = false
    }
    
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
    
    func listenForNotifications() {
        notificationGains = currentInvestmentGains.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self.configureArithmetic()
                self.miniTableView.reloadData()
                self.updateChartWithData()
            case .initial:
                self.configureArithmetic()
                self.miniTableView.reloadData()
                self.updateChartWithData()
            case .error:
                print("error")
            }
        })
        
        notificationWithdrawals = currentInvestmentWithdrawals.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self.configureArithmetic()
                self.miniTableView.reloadData()
                self.updateChartWithData()
            case .initial:
                self.configureArithmetic()
                self.miniTableView.reloadData()
                self.updateChartWithData()
            case .error:
                print("error")
            }
        })
        
        notificationDeposits = currentInvestmentDeposits.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .update:
                self.configureArithmetic()
                self.miniTableView.reloadData()
                self.updateChartWithData()
            case .initial:
                self.configureArithmetic()
                self.miniTableView.reloadData()
                self.updateChartWithData()
            case .error:
                print("error")
            }
        })
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
}
