//
//  ViewController.swift
//  QExpandableTableView
//
//  Created by Rupin Bhalla on 03/25/2016.
//  Copyright (c) 2016 Rupin Bhalla. All rights reserved.
//

import UIKit
import QExpandableTableView

class ViewController: UIViewController
{
    @IBOutlet weak var ExTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *  This will load all cell attributes from the p-list. You will have to make the p-list yourself.
     *  Once you make the p-list you can specifiy what rows you can put it and then this method will allow you
     to load those contents into an array called cellDescriptors that you will use throughout the project.
     */
    public func loadCellDescriptors()
    {
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist")
        {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            ExTableView.reloadData();
            
            
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
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        
        if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpandable"] as! Bool == true
        {
            var shouldExpandAndShowSubRows = false
            if cellDescriptors[indexPath.section][indexOfTappedRow]["isExpanded"] as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow]["additionalRows"] as! Int))
            {
                cellDescriptors[indexPath.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
            
        }
        getIndicesOfVisibleRows()
        ExTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }

}

