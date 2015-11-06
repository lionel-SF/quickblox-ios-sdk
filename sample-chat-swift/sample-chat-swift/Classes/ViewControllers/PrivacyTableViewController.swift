//
//  PrivacyTableViewController.swift
//  sample-chat-swift
//
//  Created by Vitaliy Gorbachov on 11/6/15.
//  Copyright © 2015 quickblox. All rights reserved.
//

import Foundation

enum UserPrivacyStatus: Int {
    case notLoaded = 0
    case blocked
    case notBlocked
}

class PrivacyTableViewController: UITableViewController, QBChatDelegate {
    
    var user: QBUUser?
    var userPrivacyStatus: UserPrivacyStatus!
    var privacyList: QBPrivacyList?
    
    // MARK: ViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.user?.fullName
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribing for QBChat delegates
        QBChat.instance().addDelegate(self)
        
        // retieve privacy list
        QBChat.instance().retrievePrivacyListWithName("SA_STR_PRIVACY_LIST_NAME".localized)
    }
    
    // MARK: Privacy actions
    
    func blockUser() {
        SVProgressHUD.showWithStatus("Blocking user")
        
        let item1: QBPrivacyItem! = QBPrivacyItem.init(type: USER_ID, valueForType: self.user!.ID, action: DENY)
        let item2: QBPrivacyItem! = QBPrivacyItem.init(type: GROUP_USER_ID, valueForType: self.user!.ID, action: DENY)
        
        if (self.privacyList != nil) {
            self.privacyList?.addObject(item1)
            self.privacyList?.addObject(item2)
        } else {
            self.privacyList = QBPrivacyList.init(name: "SA_STR_PRIVACY_LIST_NAME".localized, items: [item1, item2])
        }
        
        self.userPrivacyStatus = UserPrivacyStatus.blocked
        
        QBChat.instance().setPrivacyList(self.privacyList)
    }
    
    func unblockUser() {
        SVProgressHUD.showWithStatus("Unblocking user")
        
        if (self.privacyList != nil) {
            let items = self.privacyList!.items.copy() as! [QBPrivacyItem]
            for item in items {
                if item.valueForType == self.user?.ID  {
                    self.privacyList!.items.removeObject(item)
                }
            }
        }
        
        self.userPrivacyStatus = UserPrivacyStatus.notBlocked
        
        QBChat.instance().setPrivacyList(self.privacyList)
    }
    
    // MARK: Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SA_STR_CELL_USER".localized, forIndexPath: indexPath) as! UserTableViewCell
        
        if self.userPrivacyStatus == UserPrivacyStatus.blocked {
            cell.userDescription = "Unblock user"
            cell.setColorMarkerText("", color: UIColor.greenColor())
        } else if self.userPrivacyStatus == UserPrivacyStatus.notBlocked {
            cell.userDescription = "Block user"
            cell.setColorMarkerText("", color: UIColor.redColor())
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.userPrivacyStatus == UserPrivacyStatus.blocked {
            self.unblockUser()
        } else if self.userPrivacyStatus == UserPrivacyStatus.notBlocked {
            self.blockUser()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: QBChatDelegate
    
    // receive privacy list
    
    func chatDidReceivePrivacyList(privacyList: QBPrivacyList) {
        NSLog("chatDidReceivePrivacyList: %@", privacyList);
        
        self.userPrivacyStatus = UserPrivacyStatus.notBlocked
        
        let items = privacyList.items.copy() as! [QBPrivacyItem]
        for item in items {
            if item.valueForType == self.user?.ID && item.action == DENY {
                self.userPrivacyStatus = UserPrivacyStatus.blocked
            }
        }
        
        self.privacyList = privacyList
        
        self.tableView.reloadData()
    }
    
    func chatDidNotReceivePrivacyListWithName(name: String, error: AnyObject?) {
        self.userPrivacyStatus = UserPrivacyStatus.notBlocked
        
        self.tableView.reloadData()
    }
    
    // set privacy list
    
    func chatDidSetPrivacyListWithName(name: String) {
        self.tableView.reloadData()
        
        var status: String!
        if (self.userPrivacyStatus == UserPrivacyStatus.blocked) {
            status = "blocked"
        } else {
            status = "unblocked"
        }
        
        SVProgressHUD.showSuccessWithStatus(String(format: "%@ %@", "User successfully", status))
    }
    
    func chatDidNotSetPrivacyListWithName(name: String, error: AnyObject?) {

        var status: String!
        if (self.userPrivacyStatus == UserPrivacyStatus.blocked) {
            status = "block"
            self.userPrivacyStatus = UserPrivacyStatus.notBlocked
        } else {
            status = "unblock"
            self.userPrivacyStatus = UserPrivacyStatus.blocked
        }
        
        SVProgressHUD.showErrorWithStatus(String(format: "Failed to %@ user", status))
    }
}