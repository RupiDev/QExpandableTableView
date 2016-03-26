//
//  QExpandableTableView.swift
//  Pods
//
//  Created by Rupin Bhalla on 3/25/16.
//
//

public class QExpandableTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var cellDescriptors: NSMutableArray!
    public var visibleRowsInSection = [[Int]]()
    
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
        
        tableView.registerNib(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
    }
    
    /**
    *  This will load all cell attributes from the p-list. You will have to make the p-list yourself.
    *  Once you make the p-list you can specifiy what rows you can put it and then this method will allow you
       to load those contents into an array called cellDescriptors that you will use throughout the project.
    */
    public func loadCellDescriptors(tableView: UITableView) {
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tableView.reloadData()
        }
    }
    
    /**
     Update the visibleRowsInSection array with the indexes of the cells which are currently visible
     This is called before the table view is filled with the corresponding cells
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