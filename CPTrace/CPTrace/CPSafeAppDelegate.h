//
//  CPSafeAppDelegate.h
//  CPTrace
//
//  Created by li xiao on 15-3-25.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPSafeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSString* deviceTokenReg;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
