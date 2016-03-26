//
//  QExpandableTableView.swift
//  Pods
//
//  Created by Rupin Bhalla on 3/25/16.
//
//

import Foundation
import UIKIt

// This cocoa-pod will be for used as an Expandable Table View. In this cocoa-pod you
// will be able to expand and collaspe rows according to what you need. 


var cellDescriptors: NSMutableArray!
/// This is a double array because you have section and all the rows. In this example there is only 1 section
var visibleRowsInSection = [[Int]]()

class QExpandableTableView: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTableView()
        loadCellDescriptors()
        
        //print(cellDescriptors)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This is for Custom cells but this is a basic example, so we will only expand basic cells.
    // The normal cell is just the usual cell you will see, and when you exapnd the basic cell, you will 
    // see the valuePickerCell, which contains the specific value you want to see.
    
    func configureTableView()
    {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRectZero)
        
        tblExpandable.registerNib(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tblExpandable.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        
    }
    
    /**
    *  This will load all cell attributes from the p-list. You will have to make the p-list yourself.
    *  Once you make the p-list you can specifiy what rows you can put it and then this method will allow you
       to load those contents into an array called cellDescriptors that you will use throughout the project.
    */
    func loadCellDescriptors()
    {
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist")
        {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            
            // your own tableview .reloadData()
            
            // properties that we need for this cocoa-pod
            // isExpandable = bool telling if the view can expand or not
            // isExpanded = if the cell is expanded or collapsed
            // isVisible = if the cell is visible or not
            // primaryTitle = title for the main cell
            // secondaryTitle = title fo the sub cells under the main cell
            // cellIdentifier = identifier of the custom cell that we made in the project
            // additionalRows = number of extra rows we need after the primary Cell
        }
    }
    
    /**
       This will see the visibility of all the rows to true, and thus make it appear on the app
     */
    func getIndicesOfVisibleRows()
    {
        visibleRowsInSection.removeAll()
        
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1) {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }
        
        
    }
    
    /**
     This will get the Cell Description from the plist that you want to have
     
     - parameter indexPath: keeps track of where you are in the pList
     
     - returns: This will return a String that tells you what kind of cell you have, that you made as a unique cell
     */
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject]
    {
        let indexOfVisibleRow = visibleRowsInSection[indexPath.section][indexPath.row]
        let cellDescriptor = cellDescriptors[indexPath.section][indexPath.row] as! [String: AnyObject]
        return cellDescriptor
    }
    
    /**
     Returns the number of Sections in the Table View
     
     - parameter tableView: This the tableview that you have in the app.
     
     - returns: Returns the number of sections you have in the tableview
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if cellDescriptors != nil
        {
            return cellDescriptors.count
        }
        else
        {
            return 0;
        }
    }
    
    /**
     This method will set the height for the row of the specific cells. You can add heights to your own unique cells
     
     - parameter tableView: This is the tableview that you use in the app
     - parameter indexPath: This keeps track of where you are in the tableView
     
     - returns: Returns a float for the specific cell height
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String
        {
            case "idCellNormal":
                return 60.0
            
            default:
                return 44.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(currentCellDescriptor["cellIdentifier"] as! String, forIndexPath: indexPath) as! CustomCell
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal"
        {
            if let primaryTitle = currentCellDescriptor["primaryTitle"]
            {
                cell.textLabel?.text = primaryTitle as? String
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"]
            {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker"
        {
            cell.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
        }
       
        
        return cell
    }

    
    /**
     This will return the number of Rows in the section
     
     - parameter tableView: The specific table view you want the rows of
     - parameter section:   The specific section in the table view you want the rows of
     
     - returns: Returns the number of rows in the desired section of the desired tableview
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return visibleRowsInSection[section].count
    }
    
    

}