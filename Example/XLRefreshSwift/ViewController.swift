//
//  ViewController.swift
//  XLRefreshSwift
//
//  Created by Snowgan on 04/14/2016.
//  Copyright (c) 2016 Snowgan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataCount = 2
    
    var footerView: XLRefreshFooter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.xlfooter = XLRefreshFooter(action: {
            self.dataCount += 5
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)*2)), dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.endRefresh()
            })
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}

