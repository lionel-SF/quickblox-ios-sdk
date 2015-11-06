//
//  PrivacyTableViewController.swift
//  sample-chat-swift
//
//  Created by Vitaliy Gorbachov on 11/6/15.
//  Copyright © 2015 quickblox. All rights reserved.
//

import Foundation

class PrivacyTableViewController: UITableViewController, QBChatDelegate {
    
    var user: QBUUser?
    
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
        
    }
    
    func unblockUser() {
        
    }
    
    // MARK: Table view data source
}