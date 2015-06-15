//
//  SSLViewWithBorder.m
//  SimpleSample-location_users-ios
//
//  Created by Anton Sokolchenko on 6/9/15.
//  Copyright (c) 2015 QuickBlox. All rights reserved.
//

#import "SSLViewWithBorder.h"


@implementation SSLViewWithBorder

- (void)setBorderColor:(UIColor *)borderColor {
	_borderColor = borderColor;
	[self updateUI];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
	_borderWidth = borderWidth;
	[self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
	_cornerRadius = cornerRadius;
	[self updateUI];
}

- (void)updateUI {
 
	self.layer.borderColor   = self.borderColor.CGColor;
	self.layer.borderWidth   = self.borderWidth;
	self.layer.cornerRadius  = self.cornerRadius;
	self.layer.masksToBounds = YES;
}

@end
