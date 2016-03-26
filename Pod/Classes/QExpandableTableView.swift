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


var cellDescriptors: NSMutableArray!
/// This is a double array because you have section and all the rows. In this example there is only 1 section
var visibleRowsInSection = [[Int]]()

public class QExpandableTableView: UIViewController, UITableViewDelegate, UITableViewDataSource
    
{
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // This is for Custom cells but this is a basic example, so we will only expand basic cells.
    // The normal cell is just the usual cell you will see, and when you exapnd the basic cell, you will 
    // see the valuePickerCell, which contains the specific value you want to see.
    
    public func configureTableView(tableView: UITableView)
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.registerNib(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        
    }
    
    /**
    *  This will load all cell attributes from the p-list. You will have to make the p-list yourself.
    *  Once you make the p-list you can specifiy what rows you can put it and then this method will allow you
       to load those contents into an array called cellDescriptors that you will use throughout the project.
    */
    public func loadCellDescriptors(tableView: UITableView)
    {
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist")
        {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            print(visibleRowsInSection)
            tableView.reloadData()
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
//            print((currentSectionCells as! [[String: AnyObject]]).count - 1)
            
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
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject]
    {
        print(indexPath.row)
        return cellDescriptors[0][indexPath.row] as! [String: AnyObject]
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(currentCellDescriptor["cellIdentifier"] as! String, forIndexPath: indexPath) as! UITableViewCell
        
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
        return UITableViewCell()
    }

    
    /**
     This will return the number of Rows in the section
     
     - parameter tableView: The specific table view you want the rows of
     - parameter section:   The specific section in the table view you want the rows of
     
     - returns: Returns the number of rows in the desired section of the desired tableview
     */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(visibleRowsInSection)
        if visibleRowsInSection != [] {
            return visibleRowsInSection[0].count
        }
        else {
            return 0
        }
    }
    
    
    
}