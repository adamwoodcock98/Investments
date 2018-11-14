//
//  InvestmentsViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 17/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class InvestmentsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let realm = try! Realm()
    let cellSpacing : CGFloat = 5.0
    
    var investmentArray : Results<Investments>?
    var notificationToken : NotificationToken? = nil
    var selectedInvestmentID : String = ""
    var isNewInvestment : Bool? {
        didSet {
            tableView.reloadData()
            isNewInvestment = nil
            print("Yes! This has a new investment")
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss Keyboard When Tapped Around
        self.dismissKeyboard()

        //TableView Configuration
        configureTable()
        
        //Functions
        loadInvestments()
        
        //Hide Back Button
        self.navigationItem.hidesBackButton = true
        
        //Notifications
        listenForNotifications()
        
        //Display a label if the table is blank
        isTableBlank()
        
    }
    
    //MARK: - Functions
    
    
    //MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "investmentCell", for: indexPath) as! InvestmentsCell
        
        
        if let item = investmentArray?[indexPath.section] {
            let totalAsString = "\(item.runningTotal.rounded2DecimalPlaces)"
            let convertedTotal = Constants.convertStringToFormattedString(input: totalAsString)
            cell.title.text = item.title
            cell.percentChange.text = "\(item.mostRecentGain)%"
            cell.price.text = convertedTotal.stringValue
        } else {
            cell.title.text = "Example Investment"
            cell.percentChange.text = "14.58%"
            cell.price.text = "£22,582.11"
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Constants.placeholderGrey
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return investmentArray?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Use indexpath.section instead of indexpath.row
        
        selectedInvestmentID = investmentArray![indexPath.section].id
        performSegue(withIdentifier: "goToNewInvestmentLook", sender: self)
    }
    
    //Assigning the swipe to delete actions for the tableview
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let cellToDelete = self.investmentArray![indexPath.section]
            
            do {
                try self.realm.write {
                    self.realm.delete(cellToDelete)
                }
            } catch {
                let alert = UIAlertController(title: "Error", message: "There has been an error deleting this investment, please close the app and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        return [delete]
    }
    
    
    //MARK: - TableView Configuration Function
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "InvestmentsCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "investmentCell")
        tableView.separatorStyle = .none
    }
    
    func isTableBlank() {
        if investmentArray?.count == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
    }
    
    //MARK: - Realm Functions
    
    //Setup notifications to reload tableview when data is changed.
    func listenForNotifications() {
        //Assign an observation for our results to the notification token, registering for changes in the collection.
        notificationToken = investmentArray?.observe({ (changes: RealmCollectionChange) in
            //Switch from the different results from the changes
            switch changes {
            case .initial:
                self.isTableBlank()
                self.tableView.reloadData()
            case .update:
                self.isTableBlank()
                self.tableView.reloadData()
            case .error(let error):
                print("\(error)")
            }
        })
        
    }
    
    //Load all investments and assign them to investmentArray
    func loadInvestments() {
        investmentArray = realm.objects(Investments.self).sorted(byKeyPath: "title", ascending: true)
        
        if investmentArray!.count <= 3 {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        tableView.reloadData()
    }
    
    //MARK: - IBActions
    @IBAction func newInvestmentTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToNewInvestment", sender: self)
    }
    
    //MARK: - Segue Preparations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewInvestmentLook" {
            let destination = segue.destination as! InvestmentLookViewController
            
            destination.investmentID = selectedInvestmentID
        }
    }


}

