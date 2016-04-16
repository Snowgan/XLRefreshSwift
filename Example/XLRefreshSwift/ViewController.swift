//
//  ViewController.swift
//  XLRefreshSwift
//
//  Created by Snowgan on 04/14/2016.
//  Copyright (c) 2016 Snowgan. All rights reserved.
//

import UIKit
import XLRefreshSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArr = ["d", "e", "f", "g", "h", "i", "j", "k", "l"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.xlheader = XLRefreshHeader(action: {
            self.dataArr.insert("a", atIndex: 0)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)*2)), dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.endHeaderRefresh()
            })
        })
        
        tableView.xlfooter = XLRefreshFooter(action: {
            self.dataArr.append("m")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC)*2)), dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.endFooterRefresh()
            })
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = dataArr[indexPath.row]
        return cell!
    }
}

