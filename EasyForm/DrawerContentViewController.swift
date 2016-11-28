//
//  DrawerPreviewContentViewController.swift
//  Pulley
//
//  Created by Brendan Lee on 7/6/16.
//  Copyright © 2016 52inc. All rights reserved.
//

import UIKit
import Parse

class DrawerContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PulleyDrawerViewControllerDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var gripperView: UIView!
    
    @IBOutlet var seperatorHeightConstraint: NSLayoutConstraint!
    
    let parseApi = ParseApi.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gripperView.layer.cornerRadius = 2.5
        seperatorHeightConstraint.constant = 1.0 / UIScreen.main.scale
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadResults), name:NSNotification.Name(rawValue: "reloadProviders"), object: nil)
    }
    
    func reloadResults(){
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview data source & delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseApi.feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCell" , for: indexPath) as! ProviderCell
        
        let request: PFObject = parseApi.feedArray .object(at: indexPath.row) as! PFObject
        
        let lastName = request["lastName"] as? String
        let firstName = request["firstName"] as? String
        
        cell.name.text = String(format: "%@ %@", firstName!,lastName!)
        cell.subtitle.text = request["speciality"] as? String
        
        cell.providerImage.layer.cornerRadius = 25
        cell.providerImage.clipsToBounds = true
        
        cell.fillFormsButton.layer.cornerRadius = 10
        cell.fillFormsButton.clipsToBounds = true
        
        cell.fillFormsButton.tag = indexPath.row;
        cell.fillFormsButton.addTarget(self, action:#selector(formsButtonPressed), for: .touchUpInside)
        
 
        let userImage = request.value(forKey: "image") as? PFFile
        userImage?.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                let image = UIImage(data:imageData!)
                cell.providerImage.image = image
                
            }else{
                print("Error: \(error)")
            }
        })

        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let drawer = self.parent as? PulleyViewController
        {
            let primaryContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryTransitionTargetViewController")
            
            drawer.setDrawerPosition(position: .collapsed, animated: true)

            drawer.setPrimaryContentViewController(controller: primaryContent, animated: false)
        }
    }

    // MARK: Drawer Content View Controller Delegate
    
    func collapsedDrawerHeight() -> CGFloat
    {
        return 68.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return 264.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }

    func drawerPositionDidChange(drawer: PulleyViewController)
    {
        tableView.isScrollEnabled = drawer.drawerPosition == .open
        
        if drawer.drawerPosition != .open
        {
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK: Search Bar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
        if let drawerVC = self.parent as? PulleyViewController
        {
            drawerVC.setDrawerPosition(position: .open, animated: true)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
          searchBar.showsCancelButton = false
    }
    
    func formsButtonPressed(sender: UIButton){
        let storyboard : UIStoryboard = UIStoryboard(name: "Forms1", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FormNav")
        self.present(vc, animated: true, completion: nil)    }
}
