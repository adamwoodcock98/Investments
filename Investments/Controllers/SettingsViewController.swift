//
//  SettingsViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 14/11/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellSpacing = CGFloat(5.0)
    
    var titleArray = ["App Roadmap - Trello Board", "Feedback"]
    var subtitleArray = ["See whats coming next, request features and report bugs", "Have your say"]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        
    }
    //MARK: - Functions
    
    //Configure table
    func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    //Compose an email
    func sendEmail(indexPath: IndexPath) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["investmentsmanagerapp@gmail.com"])
            mail.setSubject("Feedback")
            mail.setMessageBody("<html> <body> If reporting a bug or requesting a feature, please visit the Trello board, if proving feedback in regards to an isolated problem with your device, please include the model of your device and the iOS version you are running. For more information about your device model and version please visit <a href=\"https://support.apple.com/en-gb/HT201685\">this support article.</a> </body> </html>", isHTML: true)
            
            present(mail, animated: true) {
                self.tableView.deselectRow(at: indexPath, animated: false)
            }
        } else {
            let alert = UIAlertController(title: "Something went wrong", message: "There has been a problem trying to create an email, please try again or email directly at: investmentsmanagerapp@gmail.com", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - TableView Delegate/Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = titleArray[indexPath.section]
        cell.textLabel?.textColor = Constants.mainTextGrey
        cell.textLabel?.font = UIFont(name: "SourceSansPro-SemiBold", size: 26)
        cell.detailTextLabel?.text = subtitleArray[indexPath.section]
        cell.detailTextLabel?.textColor = Constants.mainTextGrey
        cell.textLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 20)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = Constants.placeholderGrey
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let url = URL(string: "https://trello.com/b/Z4fMsbvS/investments")!
            UIApplication.shared.open(url, options: [:]) { (bool) in
                tableView.deselectRow(at: indexPath, animated: false)
            }
        case 1:
            sendEmail(indexPath: indexPath)
        default:
            return
        }
    }
    
    //MARK: Mail Composer Delegate Methods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
