//
//  SelectionTVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/28/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit

class SelectionTVC: UITableViewController {
    
    var selectionArray: NSArray! = []
    var titleString: String!
    
//    var selection = [Any]()
//    var lastSelection: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let logoutButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneButtonPressed))
        navigationItem.rightBarButtonItem = logoutButton
        
        self.navigationItem.title = titleString
        self.tableView.allowsMultipleSelection = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
//        if(UserDefaults.standard.value(forKey: "lastSelection") != nil){
//        
//        }
//        selection = [UserDefaults.standard.set((selection), forKey: "lastSelection") as Any]
//        UserDefaults.standard.synchronize()

    }
    
    func doneButtonPressed(){
        self.navigationController?.popViewController(animated: true)
//        UserDefaults.standard.value(forKey: "lastSelection")
//        UserDefaults.standard.synchronize()
//        UserDefaults.standard.set((selection), forKey: "lastSelection")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectionArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
        
        cell.title.text  = selectionArray .object(at: indexPath.row) as? String

        cell.checkImageView?.isHidden = true
        
//        let checkMarkToDisplay = UserDefaults.standard.value(forKey: "lastSelection") as! NSArray
        
//        print(checkMarkToDisplay)
//        let checkmark = checkMarkToDisplay[indexPath.row]
//        
//        print(checkmark)
        
//        if (indexPath.row == checkMarkToDisplay){
//            
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//            }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell!.isSelected == true
        {
//            selection.append(indexPath.row)
            cell!.accessoryType = .checkmark
        }
        else
        {
            cell!.accessoryType = .none
        }
        
//        UserDefaults.standard.set((selection), forKey: "lastSelection")
//        UserDefaults.standard.synchronize()
        
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell!.isSelected == true
        {
//            selection.append(indexPath.row)
            cell!.accessoryType = .checkmark
        }
        else
        {
//            selection.remove(at:indexPath.row)
            cell!.accessoryType = .none
        }
        
//        UserDefaults.standard.set((selection), forKey: "lastSelection")
//        UserDefaults.standard.synchronize()
        
    }
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! SelectionCell
//        
//        cell.title.text  = selectionArray .object(at: indexPath.row) as? String
//        
//        cell.checkImageView?.isHidden = true
//        
//        let checkMarkToDisplay = UserDefaults.standard.value(forKey: "lastSelection") as! Int
//        
//        //        if(checkMarkToDisplay == indexPath.row) {
//        //            cell.accessoryType = .checkmark
//        //        }
//        //        else{
//        ////            cell.accessoryType = .none
//        //        }
//        
//        return cell
//    }

    //    var lastSelection: NSIndexPath!
    //
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let checkMarkToDisplay = UserDefaults.standard.value(forKey: "lastSelection") as! Int
    //        lastSelection = NSIndexPath(row: checkMarkToDisplay, section: 0)
    //
    //        if self.lastSelection != nil
    //        {
    //            self.tableView.cellForRow(at: lastSelection as IndexPath)?.accessoryType = .none
    //        }
    //
    //        if indexPath.row > 0
    //        {
    //            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    //
    //            self.lastSelection = indexPath as NSIndexPath!
    //
    //            self.tableView.deselectRow(at: indexPath, animated: true)
    //        }
    //
    //        UserDefaults.standard.set(indexPath.row, forKey: "lastSelection")
    //
    ////        let cell = tableView.cellForRow(at: indexPath)
    ////
    ////        if cell!.isSelected == true
    ////        {
    ////            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
    ////        }
    ////        else
    ////        {
    ////            cell!.accessoryType = UITableViewCellAccessoryType.none
    ////        }
    //    }
    
