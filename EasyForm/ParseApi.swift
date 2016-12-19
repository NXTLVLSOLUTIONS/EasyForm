//
//  ParseApi.swift
//  EasyForm
//
//  Created by Rahiem Klugh on 11/20/16.
//  Copyright © 2016 TouchCore Logic, LLC. All rights reserved.
//


import Foundation
import Parse


class ParseApi {
//    class var sharedInstance: ParseApi {
//        struct Static {
//            static var instance: ParseApi?
//            static var token: dispatch_once_t = 0
//        }
//        
//        dispatch_once(&Static.token) {
//            Static.instance = ParseApi()
//        }
//        
//        return Static.instance!
//    }
    
    //MARK: Shared Instance
    
    static let sharedInstance : ParseApi = {
        let instance = ParseApi()
        return instance
    }()
    
    //MARK: Local Variable
    
    var emptyStringArray : [String]? = nil
    
    //MARK: Init
    
    convenience init() {
        self.init(array : [])
    }
    
    //MARK: Init Array
    
    init( array : [String]) {
        emptyStringArray = array
    }
    
    var feedArray : NSMutableArray = []

    func fetchAllBusinesses(){
        
        KVNProgress.show()
        
        feedArray = []
        
        let feedQuery:PFQuery = PFQuery(className: "Providers")
        
        feedQuery.findObjectsInBackground{ (objects,error) -> Void in
            if error == nil {
                
                for object: PFObject in objects! as [PFObject] {
                    self.feedArray.add(object)
                }
                
                KVNProgress.dismiss()

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadProviders"), object: nil)
            }
        }
    }
}

