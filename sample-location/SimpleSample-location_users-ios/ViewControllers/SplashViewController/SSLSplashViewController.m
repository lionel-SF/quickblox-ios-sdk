//
//  SplashViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Danil on 04.10.11.
//  Copyright 2011 QuickBlox. All rights reserved.
//

#import "SSLSplashViewController.h"
#import "SSLAppDelegate.h"
#import "SSLDataManager.h"


@interface SSLSplashViewController ()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *wheel;

@end

@implementation SSLSplashViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
	__weak __typeof(self)weakSelf = self;
	
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {        

		[QBRequest objectsWithClassName:@"bank" extendedRequest:nil successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
			NSMutableArray *checkins = [NSMutableArray array];
			
			for( QBCOCustomObject *object in objects ){
				SSLGeoData *geo = [SSLGeoData geoData];
				geo.geoData.longitude = [object.fields[@"longitude"] doubleValue];
				geo.geoData.latitude = [object.fields[@"latitude"] doubleValue];
				geo.name = object.fields[@"name"];
				geo.branch = object.fields[@"branch"];
				geo.address = object.fields[@"address"];
				geo.cityName = object.fields[@"city_name"];
				[checkins addObject:geo];
			}
			
			[SSLDataManager.instance saveCheckins:checkins];
			SSLAppDelegate *appDelegate = (SSLAppDelegate *)[UIApplication sharedApplication].delegate;
			
			[weakSelf presentViewController:appDelegate.menuController animated:YES completion:nil];
			
		} errorBlock:^(QBResponse *response) {
			NSLog(@"Error = %@", response.error);
		}];
		
        
    } errorBlock:^(QBResponse *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                        message:[response.error description]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end