//
//  ChatService.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/21/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationDialogsUpdated @"kNotificationDialogsUpdated"
#define kNotificationChatDidAccidentallyDisconnect @"kNotificationСhatDidAccidentallyDisconnect"
#define kNotificationChatDidReconnect @"kNotificationChatDidReconnect"
#define kNotificationGroupDialogJoined @"kNotificationGroupDialogJoined"

@protocol ChatServiceDelegate <NSObject>
- (BOOL)chatDidReceiveMessage:(QBChatMessage *)message;
- (BOOL)chatDidDeleteMessage:(QBChatMessage *)message;
- (void)chatDidLogin;
@end

@interface ChatService : NSObject

@property (readonly) BOOL isConnected;

@property (weak) id<ChatServiceDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, readonly) NSMutableDictionary *usersAsDictionary;

@property (nonatomic, strong) NSMutableArray *dialogs;
@property (nonatomic, readonly) NSMutableDictionary *dialogsAsDictionary;
@property (nonatomic, strong) NSMutableDictionary *messages;

+ (instancetype)shared;

- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock;
- (void)logout;

- (BOOL)sendMessage:(NSString *)messageText toDialog:(QBChatDialog *)dialog;

- (NSMutableArray *)messagsForDialogId:(NSString *)dialogId;
- (void)addMessages:(NSArray *)messages forDialogId:(NSString *)dialogId;
- (void)addMessage:(QBChatMessage *)message forDialogId:(NSString *)dialogId;

- (BOOL)removeMessage:(QBChatMessage *)message forDialogId:(NSString *)dialogId;

- (void)requestDialogsWithCompletionBlock:(void(^)())completionBlock;
- (void)requestDialogUpdateWithId:(NSString *)dialogId completionBlock:(void(^)())completionBlock;
- (void)sortDialogs;

@end
