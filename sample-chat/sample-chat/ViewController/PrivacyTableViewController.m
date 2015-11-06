//
//  PrivacyTableViewController.m
//  sample-chat
//
//  Created by Vitaliy Gorbachov on 11/5/15.
//  Copyright © 2015 Quickblox. All rights reserved.
//

#import "PrivacyTableViewController.h"
#import "UserTableViewCell.h"

typedef NS_ENUM(NSUInteger, UserPrivacyStatus) {
    UserPrivacyStatusNotLoaded   = 0,
    UserPrivacyStatusBlocked     = 1,
    UserPrivacyStatusNotBlocked  = 2
};

@interface PrivacyTableViewController () <QBChatDelegate>

@property (assign, nonatomic) UserPrivacyStatus userPrivacyStatus;
@property (strong, nonatomic) QBPrivacyList *privacyList;

@end

@implementation PrivacyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.title = self.user.fullName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // subscribing for QBChat delegates
    [[QBChat instance] addDelegate:self];
    
    // retieve privacy list
    [[QBChat instance] retrievePrivacyListWithName:kPrivacyListName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[QBChat instance] removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Privacy actions

- (void)blockUser {
    [SVProgressHUD showWithStatus:@"Blocking user"];
    
    QBPrivacyItem *item1 = [[QBPrivacyItem alloc] initWithType:USER_ID valueForType:self.user.ID action:DENY];
    QBPrivacyItem *item2 = [[QBPrivacyItem alloc] initWithType:GROUP_USER_ID valueForType:self.user.ID action:DENY];
    
    if (self.privacyList != nil) {
        [self.privacyList addObject:item1];
        [self.privacyList addObject:item2];
    } else {
        self.privacyList = [[QBPrivacyList alloc] initWithName:kPrivacyListName items:@[item1, item2]];
    }
    
    self.userPrivacyStatus = UserPrivacyStatusBlocked;
    
    [[QBChat instance] setPrivacyList:self.privacyList];
}

- (void)unblockUser {
    [SVProgressHUD showWithStatus:@"Unblocking user"];
    
    if (self.privacyList != nil) {
        NSArray *privacyListItems = self.privacyList.items.copy;
        for (QBPrivacyItem *item in privacyListItems) {
            if ([item valueForType] == self.user.ID) {
                [self.privacyList.items removeObject:item];
            }
        }
    }
    
    self.userPrivacyStatus = UserPrivacyStatusNotBlocked;
    
    [[QBChat instance] setPrivacyList:self.privacyList];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UserTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserTableViewCellIdentifier forIndexPath:indexPath];
    
    switch (self.userPrivacyStatus) {
        case UserPrivacyStatusBlocked:
        {
            cell.userDescription = @"Unblock user";
            [cell setColorMarkerText:@"" andColor:[UIColor greenColor]];
        }
            break;
        case UserPrivacyStatusNotBlocked:
        {
            cell.userDescription = @"Block user";
            [cell setColorMarkerText:@"" andColor:[UIColor redColor]];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.userPrivacyStatus) {
        case UserPrivacyStatusBlocked:
        {
            [self unblockUser];
        }
            break;
        case UserPrivacyStatusNotBlocked:
        {
            [self blockUser];
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark QBChatDelegate

// receive privacy list

- (void)chatDidReceivePrivacyList:(QBPrivacyList *)privacyList{
    NSLog(@"chatDidReceivePrivacyList: %@", privacyList);
    
    self.userPrivacyStatus = UserPrivacyStatusNotBlocked;
    
    for (QBPrivacyItem *item in privacyList.items) {
        if ([item valueForType] == self.user.ID && item.action == DENY) {
            self.userPrivacyStatus = UserPrivacyStatusBlocked;
        }
    }
    
    self.privacyList = privacyList;
    
    [self.tableView reloadData];
}

- (void)chatDidNotReceivePrivacyListWithName:(NSString *)name error:(id)error{
    self.userPrivacyStatus = UserPrivacyStatusNotBlocked;
    
    [self.tableView reloadData];
}

// set privacy list

- (void)chatDidSetPrivacyListWithName:(NSString *)name{
    NSLog(@"chatDidSetPrivacyListWithName %@", name);
    
    [self.tableView reloadData];
    
    NSString *status;
    if (self.userPrivacyStatus == UserPrivacyStatusNotBlocked) {
        status = @"unblocked";
    }
    else {
        status = @"blocked";
    }
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"User successfully %@", status]];
}

- (void)chatDidNotSetPrivacyListWithName:(NSString *)name error:(id)error{
    NSLog(@"chatDidNotSetPrivacyListWithName: %@ due to error:%@", name, error);
    
    NSString *status;
    if (self.userPrivacyStatus == UserPrivacyStatusNotBlocked) {
        status = @"unblock";
        self.userPrivacyStatus = UserPrivacyStatusBlocked;
    }
    else {
        status = @"block";
        self.userPrivacyStatus = UserPrivacyStatusNotBlocked;
    }
    
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Failed to %@ user", status]];
}

@end
