//
//  SSLMenuTableViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Anton Sokolchenko on 6/9/15.
//  Copyright (c) 2015 QuickBlox. All rights reserved.
//

#import "SSLMenuTableViewController.h"
#import "SSLAppDelegate.h"
#import "SSLMapViewController.h"

@implementation SSLMenuTableViewController

NSString *kGoToMapKey = @"goToMap";

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if( indexPath.row == 3 ) {// near me
		
		[self performSegueWithIdentifier:kGoToMapKey sender:@(3)];
	}
	else if( indexPath.row == 4 ){ // bank
		[self performSegueWithIdentifier:kGoToMapKey sender:@(4)];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if( [segue.identifier isEqualToString:kGoToMapKey] ){
		SSLMapViewController *vc = segue.destinationViewController;
		if([ (NSNumber *)sender isEqualToNumber:@(3)]) {
			vc.openAtUserLocation = YES;
		}
		else {
			vc.openAtUserLocation = NO;
		}
	}
}

@end
