//
//  ResultsViewController.swift
//  Investments
//
//  Created by Adam Woodcock on 08/10/2018.
//  Copyright © 2018 Adam Woodcock. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    
    //Values passed over from Forecasts
    var investmentAmount : Int!
    var withdrawalAmount : Int!
    var growth : Float!
    var investmentDurationNumber : Int!
    var withdrawalDurationNumber : Int!
    var investmentDurationDate : String!
    var withdrawalDurationDate : String!
    
    //Arithmetic values
    var percentageGain : Float = 0.0
    var investmentWith1WeekGain : Double!
    var weeksInAMonth : Double = 4.33
    var investmentDurationInWeeks : Int!
    var resultsTimePeriodArray : [Int] = []
    var resultsTimePeriodDictionary : [String : Int] = [:]
    var compoundedInvestment : Float = 0
    var withdrawalFrequencyWeeks : Int = 0
    var totalWithdrawn : Float = 0.0
    var compoundedInvestmentAray : [Float] = []
    var dictionaryWithPeriodsAndValues : [(key: String, value: Float)]!

    override func viewDidLoad() {
        super.viewDidLoad()

        percentageGain = convertGrowthToPercent()
        investmentWith1WeekGain = calculateWeeklyGain()
        investmentDurationInWeeks = convertInvestmentDurationToWeeks()
        createResultsTimePeriods()
        compoundedInvestment = Float(investmentAmount)
        withdrawalFrequencyWeeks = calculateWithdrawalFrequencyWeeks()
        calculateTimePeriodValues()
        dictionaryWithPeriodsAndValues = convertResultsToDisplayFormat()
        print(dictionaryWithPeriodsAndValues)
        
    }
    
    
    //MARK: - Arithmetic Functions
    
    func convertGrowthToPercent() -> Float {
        return 1 + (growth / 100)
    }
    
    func calculateWeeklyGain() -> Double {
        return Double(Float(investmentAmount) * percentageGain)
    }
    
    //Get the number of weeks the investment is forcast to last
    func convertInvestmentDurationToWeeks() -> Int {
        if investmentDurationDate == "Months" {
            return Int(Double(Double(investmentDurationNumber) * weeksInAMonth).rounded())
        } else {
            return investmentDurationNumber
        }
    }
    
    //From the number of weeks, update the results array with incremental weekly values
    func createResultsTimePeriods() {
        if let numberOfWeeks = investmentDurationInWeeks {
          resultsTimePeriodArray = Array(1...numberOfWeeks)
        }
        
        
    }
    
    //Get the frequency of withdrawals in weeks
    func calculateWithdrawalFrequencyWeeks() -> Int {
        if withdrawalDurationDate == "Weeks" {
            return withdrawalDurationNumber
        } else if withdrawalDurationDate == "Months" {
            return Int(Float(4.33 * Float(withdrawalDurationNumber)).rounded())
        } else {
            return 0
        }
    }
    
    //From the weeks in the resultsTimePeriodArray calculate the gains each week, then substract withdrawals when applicable
    func calculateTimePeriodValues() {
        for weeks in resultsTimePeriodArray {
            compoundedInvestment = compoundedInvestment * percentageGain
            
            //If the module of the current week by the withdrawal frequency is 0, a withdrawal must be made on this iteration
            let remainder = weeks % withdrawalFrequencyWeeks
            if remainder == 0 {
                compoundedInvestment = compoundedInvestment - Float(withdrawalAmount)
                totalWithdrawn += Float(withdrawalAmount)
            }
            //Add the new investment figure to the array
            compoundedInvestmentAray.append(compoundedInvestment)
        }
    }
    
    func convertResultsToDisplayFormat() -> [(key: String, value: Float)]{
        switch resultsTimePeriodArray.max() {
        case 1: resultsTimePeriodDictionary = Constants2.dictionary4Weeks
        case 2: resultsTimePeriodDictionary = Constants2.dictionary4Weeks
        case 3: resultsTimePeriodDictionary = Constants2.dictionary4Weeks
        case 4: resultsTimePeriodDictionary = Constants2.dictionary4Weeks
        case 9: resultsTimePeriodDictionary = Constants2.dictionary2Months
        case 13: resultsTimePeriodDictionary = Constants2.dictionary3Months
            
        case 17: resultsTimePeriodDictionary = Constants2.dictionary4Months
        case 22: resultsTimePeriodDictionary = Constants2.dictionary5Months
        case 26: resultsTimePeriodDictionary = Constants2.dictionary6Months
            
        case 30: resultsTimePeriodDictionary = Constants2.dictionary7Months
        case 35: resultsTimePeriodDictionary = Constants2.dictionary8Months
        case 39: resultsTimePeriodDictionary = Constants2.dictionary9Months
            
        case 43: resultsTimePeriodDictionary = Constants2.dictionary10Months
        case 48: resultsTimePeriodDictionary = Constants2.dictionary11Months
        case 52: resultsTimePeriodDictionary = Constants2.dictionary12Months
            
        case 56: resultsTimePeriodDictionary = Constants2.dictionary13Months
        case 61: resultsTimePeriodDictionary = Constants2.dictionary14Months
        case 65: resultsTimePeriodDictionary = Constants2.dictionary15Months
            
        case 69: resultsTimePeriodDictionary = Constants2.dictionary16Months
        case 74: resultsTimePeriodDictionary = Constants2.dictionary17Months
        case 78: resultsTimePeriodDictionary = Constants2.dictionary18Months
            
        case 82: resultsTimePeriodDictionary = Constants2.dictionary19Months
        case 87: resultsTimePeriodDictionary = Constants2.dictionary20Months
        case 91: resultsTimePeriodDictionary = Constants2.dictionary21Months
            
        case 95: resultsTimePeriodDictionary = Constants2.dictionary22Months
        case 100: resultsTimePeriodDictionary = Constants2.dictionary23Months
        case 104: resultsTimePeriodDictionary = Constants2.dictionary24Months
            
        case 108: resultsTimePeriodDictionary = Constants2.dictionary25Months
        case 113: resultsTimePeriodDictionary = Constants2.dictionary26Months
        case 117: resultsTimePeriodDictionary = Constants2.dictionary27Months
            
        case 121: resultsTimePeriodDictionary = Constants2.dictionary28Months
        case 126: resultsTimePeriodDictionary = Constants2.dictionary29Months
        case 130: resultsTimePeriodDictionary = Constants2.dictionary30Months
            
        case 134: resultsTimePeriodDictionary = Constants2.dictionary31Months
        case 139: resultsTimePeriodDictionary = Constants2.dictionary32Months
        case 143: resultsTimePeriodDictionary = Constants2.dictionary33Months
            
        case 147: resultsTimePeriodDictionary = Constants2.dictionary34Months
        case 152: resultsTimePeriodDictionary = Constants2.dictionary35Months
        case 156: resultsTimePeriodDictionary = Constants2.dictionary36Months
            
        case 160: resultsTimePeriodDictionary = Constants2.dictionary37Months
        case 165: resultsTimePeriodDictionary = Constants2.dictionary38Months
        case 169: resultsTimePeriodDictionary = Constants2.dictionary39Months
            
        case 173: resultsTimePeriodDictionary = Constants2.dictionary40Months
        case 178: resultsTimePeriodDictionary = Constants2.dictionary41Months
        case 182: resultsTimePeriodDictionary = Constants2.dictionary42Months
            
        case 186: resultsTimePeriodDictionary = Constants2.dictionary43Months
        case 191: resultsTimePeriodDictionary = Constants2.dictionary44Months
        case 195: resultsTimePeriodDictionary = Constants2.dictionary45Months
            
        case 199: resultsTimePeriodDictionary = Constants2.dictionary46Months
        case 204: resultsTimePeriodDictionary = Constants2.dictionary47Months
        case 208: resultsTimePeriodDictionary = Constants2.dictionary48Months
        default: resultsTimePeriodDictionary = ["1 Week" : 1, "4 Weeks" : 4, "3 Months" : 13, "6 Months" : 26, "9 Months" : 39, "1 Year" : 52]
        }
        
        var dictionary : [String : Float] = [:]
        
        for periods in resultsTimePeriodDictionary {
            let timePeriod = periods.key
            let value = periods.value - 1
            let timePeriodValue = compoundedInvestmentAray[value]
            
            dictionary.updateValue(timePeriodValue, forKey: timePeriod)
            
        }
        
        let dictionarySorted = dictionary.sorted { (a:(key: String, value: Float), b:(key: String, value: Float)) -> Bool in
            if a.value < b.value {
                return true
            } else {
                return false
            }
        }
        return dictionarySorted
        
        //Task for tomorrow: instead of updating the dictionary in swift, persist the data with Realm Database, then this can be populated into the UI with efficient sorting.
        
        //FIXME: - When navigating back a screen you can change the values on the UI but these have no actual effect.
        
        
    }
    

}

