//
//  MapViewController.m
//  SimpleSample-location_users-ios
//
//  Created by Alexey Voitenko on 24.02.12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "SSLMapViewController.h"
#import "SSLMapPin.h"
#import "SSLDataManager.h"
#import <MTBlockAlertView.h>

@interface SSLMapViewController () <UIAlertViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIViewController *loginController;
@property (nonatomic, strong) IBOutlet UIViewController *registrationController;

@end

@implementation SSLMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Map", nil);
		self.tabBarItem.image = [UIImage imageNamed:@"globe.png"];
    }
    return self;
}
- (instancetype)init {
	self = [super init];
	if ( self ){
		self.title = NSLocalizedString(@"Map", nil);
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [CLLocationManager new];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
#endif
    [self.locationManager startUpdatingLocation];
	self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	// user blue circle
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;

	MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
	annotationView.canShowCallout = YES;
	annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	[[[UIAlertView alloc] initWithTitle:view.annotation.title message:view.annotation.subtitle delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if([self.mapView.annotations count] <= 1) {
        for(SSLGeoData *geodata in [SSLDataManager instance].checkins) {
            CLLocationCoordinate2D coord = {.latitude = geodata.geoData.latitude, .longitude = geodata.geoData.longitude};
            SSLMapPin *pin = [[SSLMapPin alloc] initWithCoordinate:coord];
            pin.subtitle = geodata.address;
			pin.title = geodata.name;
            [self.mapView addAnnotation:pin];
        }
		if( self.openAtUserLocation ){
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    		[self checkIn:nil];
			});
	
		}
		else {
			[self setRegionToLatestCheckin:nil];
		}
    }
}

- (IBAction)setRegionToLatestCheckin:(id)sender {
	SSLGeoData *last = [SSLDataManager instance].checkins.lastObject;
	CLLocationCoordinate2D lok = CLLocationCoordinate2DMake(last.geoData.latitude, last.geoData.longitude);
	MKCoordinateRegion region = MKCoordinateRegionMake(lok, MKCoordinateSpanMake(0.05f, 0.05f));
	[self.mapView setRegion:region animated:YES];
}

- (IBAction)checkIn:(id)sender
{
	float spanX = 0.01725;
	float spanY = 0.01725;
	MKCoordinateRegion region;
	region.center.latitude = self.mapView.userLocation.coordinate.latitude;
	region.center.longitude = self.mapView.userLocation.coordinate.longitude;
	region.span.latitudeDelta = spanX;
	region.span.longitudeDelta = spanY;
	[self.mapView setRegion:region animated:YES];

}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // User didn't auth  alert
    if(alertView.tag == 1) {
        
    // Check in   alert
    }else if(alertView.tag == 2) {
        switch (buttonIndex) {
            case 1: {

                
                break;
            }
            default:
                break;
        }
    }
}


@end
