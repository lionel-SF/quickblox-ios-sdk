//
//  SSLGeoData.h
//  SimpleSample-location_users-ios
//
//  Created by Anton Sokolchenko on 6/4/15.
//  Copyright (c) 2015 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSLGeoData : NSObject

+ (instancetype)geoData;

@property (nonatomic, strong) QBLGeoData *geoData;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *branch;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *cityName;

@end
