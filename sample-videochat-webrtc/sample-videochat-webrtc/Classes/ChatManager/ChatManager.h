//
//  ChatManager.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 12.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatManager : NSObject

+ (instancetype)instance;

- (void)logInWithUser:(QBUUser *)user completion:(void (^)(BOOL error))completion disconnectedBlock:(void(^)())disconnectedBlock reconnectedBlock:(void(^)())reconnectedBlock;
- (void)logOut;

@end