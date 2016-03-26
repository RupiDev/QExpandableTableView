//
//  ViewController.swift
//  QExpandableTableView
//
//  Created by Rupin Bhalla on 03/25/2016.
//  Copyright (c) 2016 Rupin Bhalla. All rights reserved.
//

import UIKit
import QExpandableTableView

class ViewController: QExpandableTableView
{
    @IBOutlet weak var ExTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        super.configureTableView(ExTableView)
        super.loadCellDescriptors(ExTableView)
        
        //print(cellDescriptors)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

