//
//  CPSafeAppDelegate.m
//  CPTrace
//
//  Created by li xiao on 15-3-25.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeAppDelegate.h"
#import "UMessage.h"
#import "CPSafeWebViewViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface CPSafeAppDelegate()
@property (strong,nonatomic,retain) NSMutableDictionary* muuserInfo;
@end

@implementation CPSafeAppDelegate

@synthesize deviceTokenStr=_deviceTokenStr;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize deviceTokenReg=_deviceTokenReg;
@synthesize muuserInfo;
#pragma mark - UMengNotificationDelegate
//注册远程通知类型
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    NSLog(@"start info,%@",launchOptions);
        //set AppKey and AppSecret
        [UMessage startWithAppkey:@"552646a2fd98c521000018c7" launchOptions:launchOptions];
        
        //register remoteNotification types
        
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
                                                    |UIRemoteNotificationTypeSound
         
         |UIRemoteNotificationTypeAlert];
        
        
        //for log（optional）
        [UMessage setLogEnabled:YES];
    
   // NSLog(@"lauchOptions:%@",launchOptions);
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
        return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    
    
    
    //获取device token
    
    _deviceTokenReg = [NSString stringWithFormat:@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]];
    _deviceTokenStr = [NSString stringWithFormat:@"%@",[deviceToken description]];
   
    _deviceTokenStr = [_deviceTokenStr substringFromIndex:[_deviceTokenStr rangeOfString:@"<"].location+1];
    _deviceTokenStr = [_deviceTokenStr substringToIndex:[_deviceTokenStr rangeOfString:@">"].location];
    _deviceTokenStr = [_deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];

}

//接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    
    //应用运行时的消息处理
    [UMessage didReceiveRemoteNotification:userInfo];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    NSLog(@"%@",[userInfo objectForKey:@"desturl"]);
//     NSLog(@"userInfo%@",userInfo);
//    [self.muuserInfo setDictionary:[userInfo copy]];
//    [self.muuserInfo setObject:[userInfo objectForKey:@"targetUrl"] forKey:@"targetUrl"];
//    NSLog(@"muuserinfo%@",self.muuserInfo);
        //定制自定的的弹出框
//        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:[userInfo objectForKey:@"alert"]
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",nil];
    
            [alertView show];
    
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"%@",self.muuserInfo);
        NSLog(@"%@",[self.muuserInfo objectForKey:@"targetUrl"]);
        CPSafeWebViewViewController* targetUrl = [CPSafeWebViewViewController new];
        targetUrl.webURL = [self.muuserInfo objectForKey:@"targetUrl"];
        [self.window.rootViewController presentViewController:targetUrl animated:YES completion:nil];

    }}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CPTrace" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CPTrace.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"%@",NSHomeDirectory() );
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
