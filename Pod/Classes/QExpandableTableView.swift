//
//  QExpandableTableView.swift
//  Pods
//
//  Created by Rupin Bhalla on 3/25/16.
//
//

import Foundation

// This cocoa-pod will be for used as an Expandable Table View. In this cocoa-pod you
// will be able to expand and collaspe rows according to what you need. 

/**
 This class is the QExpandableTableView class. It inherits from UITableViewDelegate and UITableViewDataSource.
 This class contains the methods that allow the user to have an expandable table view. As long you specify in the
 plist, this class will read all the information from the plist and display the information as an expandable table view
*/
public class QExpandableTableView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    /// This array wil contain all the information in the plist into this array. We pull all the information from this array
    var cellDescriptors: NSMutableArray!
    
    /// This is a double array because you have section and all the rows. In this example there is only 1 section
    var visibleRowsInSection = [[Int]]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /**
     Assigns tableview delegates and registers all required nibs for cells
     
     - parameter tableView: the tableView which will be given from the child class
     */
    public func configureTableView(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Assigns a xib file with the cell identifier
        tableView.registerNib(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
    }
    
    /**
    *  This will load all cell attributes from the p-list. You will have to make the p-list yourself.
    *  Once you make the p-list you can specifiy what rows you can put it and then this method will allow you
       to load those contents into an array called cellDescriptors that you will use throughout the project.
    */
    public func loadCellDescriptors(tableView: UITableView) {
        //Locates the plist file and load it into the table view
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tableView.reloadData()
        }
    }
    
    /**
       This method will recieve all the indices of the visible rows in each section. After it revieves all the indices
       it will append to the same array. So after this method is called you will have an array of all the visible
     */
    func getIndicesOfVisibleRows() {
        
        visibleRowsInSection.removeAll()//To prevent duplicate cells
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...( ( currentSectionCells as! [[String: AnyObject]] ).count - 1) {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            visibleRowsInSection.append(visibleRows)
        }
    }
    
    /**
     This will get the Cell Description from the plist that you want to have
     
     - parameter indexPath: keeps track of where you are in the pList
     
     - returns: This will return a String that tells you what kind of cell you have, that you made as a unique cell
     */
    func getCellDescriptorForIndexPath(index: Int) -> [String: AnyObject] {
        return cellDescriptors[0][index] as! [String: AnyObject]
    }
    
    /**
     This function allows the user to select the current cell. If the cell you want is a custom cell, you can decide 
     it there. It will return the specific cell of that indexPath
     
     - parameter tableView: This is the tableview that you are working and you want to insert into the tableview
     - parameter indexPath: This is the specific indexPath that you are at.
     
     - returns: This method returns the cell.
     */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let actualIndex = visibleRowsInSection[0][indexPath.row]
        let currentCellDescriptor = getCellDescriptorForIndexPath(actualIndex)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(currentCellDescriptor["cellIdentifier"] as! String, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        if currentCellDescriptor["isVisible"] as! Int == 1 {
            if (currentCellDescriptor["primaryTitle"] as! String).characters.count > 0 {
                print("primary")
                cell.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
            }
            else if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                print("\(secondaryTitle)")
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        
        return cell
    }
    
    /**
     This method will be activated when you selected a certain row/cell. This method will do the collasping and expanding
     of the expandable table view 
     
     - parameter tableView: This is the tableview that you are working on
     - parameter indexPath: This is the indexPath that you are on during the tableView
     */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexOfTappedRow = visibleRowsInSection[indexPath.section][indexPath.row]
        
        if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] as! Bool == false {
                shouldExpandAndShowSubRows = true
            }
            
            cellDescriptors[indexPath.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow]["additionalRows"] as! Int)) {
                cellDescriptors[indexPath.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        
        getIndicesOfVisibleRows()
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.None)
    }
    
    /**
     This will return the number of Rows in the section
     
     - parameter tableView: The specific table view you want the rows of
     - parameter section:   The specific section in the table view you want the rows of
     
     - returns: Returns the number of rows in the desired section of the desired tableview
     */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if visibleRowsInSection != [] {
            return visibleRowsInSection[0].count
        }
        else {
            return 0
        }
    }
    
    
    
}