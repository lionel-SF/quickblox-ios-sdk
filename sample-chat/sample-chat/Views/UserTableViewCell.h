//
//  UserTableViewCell.h
//  sample-chat
//
//  Created by Anton Sokolchenko on 5/26/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : SWTableViewCell

@property (strong, nonatomic) NSString *userDescription;

- (void)setColorMarkerText:(NSString *)text andColor:(UIColor *)color;

@end
