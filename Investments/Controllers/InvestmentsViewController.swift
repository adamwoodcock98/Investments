//
//  InvestmentsViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 17/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import RealmSwift

class InvestmentsViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let cellSpacing : CGFloat = 5.0
    
    var investmentArray : Results<Investments>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss Keyboard When Tapped Around
        self.dismissKeyboard()

        //TableView Configuration
        configureTable()
        
        //Functions
        loadInvestments()
        
    }
    
    //MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "investmentCell", for: indexPath) as! InvestmentsCell
        
        if let item = investmentArray?[indexPath.section] {
            let totalAsString = "\(item.runningTotal)"
            let convertedTotal = Constants.convertStringToFormattedString(input: totalAsString)
            cell.title.text = item.name
            cell.percentChange.text = "\(item.mostRecentGain)%"
            cell.price.text = convertedTotal.stringValue
        } else {
            cell.title.text = "Example Investment"
            cell.percentChange.text = "14.58%"
            cell.price.text = "£22,582.11"
        }
        
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0
        cell.clipsToBounds = true
        
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
    }
    //MARK: - TableView Configuration Function
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "InvestmentsCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "investmentCell")
        tableView.estimatedRowHeight = 70
        tableView.separatorStyle = .none
    }
    
    //MARK: - Realm Functions
    
    //Load all investments and assign them to investmentArray
    func loadInvestments() {
        investmentArray = realm.objects(Investments.self).sorted(byKeyPath: "dateStarted", ascending: true)
        tableView.reloadData()
    }

}
