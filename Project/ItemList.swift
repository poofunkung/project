//
//  ItemList.swift
//  Project
//
//  Created by Pu on 4/28/15.
//  Copyright (c) 2015 Pu. All rights reserved.
//


import UIKit
import CoreData

class ItemList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data:[String] = []
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let click = NSFetchRequest(entityName: "Click")
        var results = managedContext.executeFetchRequest(click, error: nil)
        let index = results![0].valueForKey("index") as Int
        
        let list = NSFetchRequest(entityName: "List")
        results = managedContext.executeFetchRequest(list, error: nil) as [NSManagedObject]
        data = Array(arrayLiteral:
            results![index].valueForKey("username") as String,
            results![index].valueForKey("password") as String,
            results![index].valueForKey("more") as String)
        
        table.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = data[indexPath.row]
        cell.textLabel?.text = user
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
//    private func reLoad() {
//        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
//        let list = NSFetchRequest(entityName: "List")
//        data = managedContext.executeFetchRequest(list, error: nil) as! [NSManagedObject]
//        managedContext.save(nil)
//        table.reloadData()
//    }


    
    
    
}
