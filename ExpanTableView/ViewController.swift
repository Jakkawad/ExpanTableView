//
//  ViewController.swift
//  ExpanTableView
//
//  Created by admin on 11/3/2559 BE.
//  Copyright © 2559 Jakkawad.Chaiplee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomCellDelegate {
    
//    var cellDescriptors:NSMutableArray!
//    var visibleRowsPerSection = [[Int]]()
    @IBOutlet weak var tableView:UITableView!
    
    // MARK: Variables
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRowsPerSection = [[Int]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for i in 0 ..< 10 {
//            print(i)
//        }
        var i = 9 - 1
        i >= 0
        i -= 1
        do {
            if i != nil {
//                print(i)
            }
            
        }
//        for var i=9 - 1; i>=0; i -= 1 {
//            
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
        
        loadCellDescriptors()
//        print("cellDescriptors: \(cellDescriptors)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Custom Functions
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.register(UINib(nibName: "TextfieldCell", bundle: nil), forCellReuseIdentifier: "idCellTextfield")
        tableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "idCellDatePicker")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "idCellSwitch")
        tableView.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        tableView.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "idCellSlider")
    }
    
    
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tableView.reloadData()
        }
    }
    
    
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        
        for currentSectionCells in cellDescriptors.objectEnumerator().allObjects as! [[[String:Any]]] {
//            print("CurrentSectionCells: \(currentSectionCells)")
            var visibleRows = [Int]()
            for row in 0..<currentSectionCells.count {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            visibleRowsPerSection.append(visibleRows)
//            print("VisibleRow: \(visibleRows)")
        }
    }
    
    
    func getCellDescriptorForIndexPath(_ indexPath: IndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = (cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
    }
    
    
    // MARK: UITableView Delegate and Datasource Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Personal"
            
        case 1:
            return "Preferences"
            
        default:
            return "Work Experience"
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor["cellIdentifier"] as! String, for: indexPath) as! CustomCell
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
            if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                cell.textLabel?.text = primaryTitle as? String
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellTextfield" {
            cell.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSwitch" {
            cell.lblSwitchLabel.text = currentCellDescriptor["primaryTitle"] as? String
            
            let value = currentCellDescriptor["value"] as? String
            cell.swMaritalStatus.isOn = (value == "true") ? true : false
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker" {
            cell.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSlider" {
            let value = currentCellDescriptor["value"] as! String
            cell.slExperienceLevel.value = (value as NSString).floatValue
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String {
        case "idCellNormal":
            return 60.0
            
        case "idCellDatePicker":
            return 270.0
            
        default:
            return 44.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        print("indexOfTappedRow: \(indexOfTappedRow)")
        if ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject)["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject)["isExpanded"] as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
            ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject).setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject)["additionalRows"] as! Int)) {
                ((cellDescriptors[indexPath.section] as! NSMutableArray)[i] as AnyObject).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        else {
            if ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfTappedRow] as AnyObject)["cellIdentifier"] as! String == "idCellValuePicker" {
                var indexOfParentCell: Int!
                
                var i = indexOfTappedRow - 1
                i >= 0
                i -= 1
                do {
                    if ((cellDescriptors[indexPath.section] as! NSMutableArray)[i] as AnyObject)["isExpandable"] as! Bool == true {
                        indexOfParentCell = i
                        print("indexOfParentCell: \(indexOfParentCell)")
                    }
                }
//                for var i=indexOfTappedRow - 1; i>=0; i -= 1 {
//                    if ((cellDescriptors[indexPath.section] as! NSMutableArray)[i] as AnyObject)["isExpandable"] as! Bool == true {
//                        indexOfParentCell = i
//                        break
//                    }
//                }
                ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfParentCell] as AnyObject).setValue((tableView.cellForRow(at: indexPath) as! CustomCell).textLabel?.text, forKey: "primaryTitle")
                ((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfParentCell] as AnyObject).setValue(false, forKey: "isExpanded")
                
                for i in (indexOfParentCell + 1)...(indexOfParentCell + (((cellDescriptors[indexPath.section] as! NSMutableArray)[indexOfParentCell] as AnyObject)["additionalRows"] as! Int)) {
                    ((cellDescriptors[indexPath.section] as! NSMutableArray)[i] as AnyObject).setValue(false, forKey: "isVisible")
                }
            }
        }
        
        getIndicesOfVisibleRows()
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
    }
    
    
    // MARK: CustomCellDelegate Functions
    
    func dateWasSelected(_ selectedDateString: String) {
        let dateCellSection = 0
        let dateCellRow = 3
        
        ((cellDescriptors[dateCellSection] as! NSMutableArray)[dateCellRow] as AnyObject).setValue(selectedDateString, forKey: "primaryTitle")
        tableView.reloadData()
    }
    
    
    func maritalStatusSwitchChangedState(_ isOn: Bool) {
        let maritalSwitchCellSection = 0
        let maritalSwitchCellRow = 6
        
        let valueToStore = (isOn) ? "true" : "false"
        let valueToDisplay = (isOn) ? "Married" : "Single"
        
//        ((cellDescriptors[dateCellSection] as! NSMutableArray)[maritalSwitchCellRow] as AnyObject).setValue(valueToStore, forKey: "value")
//        (cellDescriptors[dateCellSection] as! NSMutableArray)[maritalSwitchCellRow - 1].setValue(valueToDisplay, forKey: "primaryTitle")
        ((cellDescriptors[maritalSwitchCellSection] as! NSMutableArray)[maritalSwitchCellRow] as AnyObject).setValue(valueToStore, forKey: "value")
        ((cellDescriptors[maritalSwitchCellSection] as! NSMutableArray)[maritalSwitchCellRow - 1] as AnyObject).setValue(valueToDisplay, forKey: "primaryTitle")
        tableView.reloadData()
    }
    
    
    func textfieldTextWasChanged(_ newText: String, parentCell: CustomCell) {
        let parentCellIndexPath = tableView.indexPath(for: parentCell)
        
        let currentFullname = ((cellDescriptors[0] as! NSMutableArray)[0] as AnyObject)["primaryTitle"] as! String
        let fullnameParts = currentFullname.components(separatedBy: " ")
        
        var newFullname = ""
        
        if parentCellIndexPath?.row == 1 {
            if fullnameParts.count == 2 {
                newFullname = "\(newText) \(fullnameParts[1])"
            }
            else {
                newFullname = newText
            }
        }
        else {
            newFullname = "\(fullnameParts[0]) \(newText)"
        }
        
        ((cellDescriptors[0] as! NSMutableArray)[0] as AnyObject).setValue(newFullname, forKey: "primaryTitle")
        tableView.reloadData()
    }
    
    
    func sliderDidChangeValue(_ newSliderValue: String) {
        ((cellDescriptors[2] as! NSMutableArray)[0] as AnyObject).setValue(newSliderValue, forKey: "primaryTitle")
        ((cellDescriptors[2] as! NSMutableArray)[1] as AnyObject).setValue(newSliderValue, forKey: "value")
        
        tableView.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.none)
    }

}

