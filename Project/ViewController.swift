//
//  ViewController.swift
//  Project
//
//  Created by Pu on 4/28/15.
//  Copyright (c) 2015 Pu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var data:[NSManagedObject] = []
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reLoad()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = data[indexPath.row].valueForKey("username") as String
        cell.textLabel?.text = user
        let qut = data[indexPath.row].valueForKey("password") as String
        let more = data[indexPath.row].valueForKey("more") as String
        //cell.detailTextLabel?.text = "จำนวน \(qut) - \(more)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let click = NSFetchRequest(entityName: "Click")
        let results = managedContext.executeFetchRequest(click, error: nil)
        
        if(results?.count > 0) {
            results![0].setValue(indexPath.row, forKey: "index")
        }else {
            let data = NSEntityDescription.insertNewObjectForEntityForName("Click", inManagedObjectContext: managedContext) as NSManagedObject
            data.setValue(indexPath.row, forKey: "index")
            managedContext.save(nil)
        }
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("detail") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.remove(indexPath.row)

    }

    @IBAction func AddTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "เพิ่มสินค้า", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "ยกเลิก", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in }
        let ok = UIAlertAction(title: "เพิ่ม", style: UIAlertActionStyle.Default) { (action:UIAlertAction!) -> Void in
            let text1:UITextField = alert.textFields![0] as UITextField
            let text2:UITextField = alert.textFields![1] as UITextField
            let text3:UITextField = alert.textFields![2] as UITextField
            self.addCore(text1.text, input2: text2.text,input3: text3.text)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    private func addCore(input1:String,input2:String,input3:String) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let data = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: managedContext) as NSManagedObject
        data.setValue(input1, forKey: "username")
        data.setValue(input2, forKey: "password")
        data.setValue(input3, forKey: "more")
        managedContext.save(nil)
        reLoad()
    }
    
    private func reLoad() {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let list = NSFetchRequest(entityName: "List")
        data = managedContext.executeFetchRequest(list, error: nil) as [NSManagedObject]
        managedContext.save(nil)
        table.reloadData()
    }
    
    private func remove(index:Int) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let list = NSFetchRequest(entityName: "List")
        data = managedContext.executeFetchRequest(list, error: nil) as [NSManagedObject]
        managedContext.deleteObject(data[index])
        data.removeAtIndex(index)
        managedContext.save(nil)
        table.reloadData()
    }
}

