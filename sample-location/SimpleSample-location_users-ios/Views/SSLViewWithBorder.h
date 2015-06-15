//
//  SSLViewWithBorder.h
//  SimpleSample-location_users-ios
//
//  Created by Anton Sokolchenko on 6/9/15.
//  Copyright (c) 2015 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>

IB_DESIGNABLE
@interface SSLViewWithBorder : UIView

@property(nonatomic)  IBInspectable UIColor *borderColor ;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
