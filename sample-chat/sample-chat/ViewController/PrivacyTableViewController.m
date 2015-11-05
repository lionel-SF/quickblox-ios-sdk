//
//  PrivacyTableViewController.m
//  sample-chat
//
//  Created by Vitaliy Gorbachov on 11/5/15.
//  Copyright © 2015 Quickblox. All rights reserved.
//

#import "PrivacyTableViewController.h"
#import "UserTableViewCell.h"

@interface PrivacyTableViewController ()

@end

@implementation PrivacyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.title = self.user.fullName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.userDescription = @"Block user";
    [cell setColorMarkerText:@"" andColor:[UIColor redColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
