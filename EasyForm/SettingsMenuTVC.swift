//
//  SettingsMenuTVC.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/21/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//

import UIKit
import MessageUI
import Fabric
import DigitsKit

class SettingsMenuTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationItem.title = "Settings"
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.logOutButtonPressed))
        navigationItem.rightBarButtonItem = logoutButton
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "CancelTopRight"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.closeButtonPressed), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 22, height: 22) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
               UIApplication.shared.statusBarStyle = .default
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0){
            return 4
        }
        else{
            return 3
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    if (indexPath.section == 0){
        
        switch (indexPath.row) {
            
        case 0:
            let storyboard = UIStoryboard(name: "MenuViews", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "@NewProfile")
            self.navigationController!.pushViewController(viewController, animated: true)
       
        case 1:
            let storyboard = UIStoryboard(name: "MenuViews", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "@insurance")
            self.navigationController!.pushViewController(viewController, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "MenuViews", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "@Payments")
            self.navigationController!.pushViewController(viewController, animated: true)
            
        case 3:
            print("TouchID Switch")

        default: break
        }
    }else{
            switch (indexPath.row) {
                
            case 0:
                self.feedbackemail()
                
            case 1:
                print("Privacy Policy")
                
            case 2:
                self.feedbackemail()
    
            default: break
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    func logOutButtonPressed(){
        
        let logOutAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertControllerStyle.alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            
            let digits = Digits.sharedInstance()
            digits.logOut()
            (UIApplication.shared.delegate! as! AppDelegate).setLoginViewController()
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //...
        }))
        
        present(logOutAlert, animated: true, completion: nil)
    }
    
    func closeButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }

   func feedbackemail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@easyform.us"])
        mailComposerVC.setSubject("Support & Feedback")
        mailComposerVC.setMessageBody("#EasyForm", isHTML: false)
        
        return mailComposerVC
        
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
