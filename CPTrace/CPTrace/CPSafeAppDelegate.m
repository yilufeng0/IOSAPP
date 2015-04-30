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
{
    NSMutableDictionary* muuserInfo;
}
@end

@implementation CPSafeAppDelegate

@synthesize deviceTokenStr=_deviceTokenStr;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize deviceTokenReg=_deviceTokenReg;

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
    
    [self->muuserInfo setDictionary:userInfo];
    NSLog(@"%@",muuserInfo);
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
    NSLog(@"%@",muuserInfo);
    if (buttonIndex == 1) {
        NSLog(@"%@",self->muuserInfo);
        NSLog(@"%@",[self->muuserInfo objectForKey:@"targetUrl"]);
        CPSafeWebViewViewController* targetUrl = [CPSafeWebViewViewController new];
        targetUrl.webURL = [self->muuserInfo objectForKey:@"targetUrl"];
        [self.window.rootViewController presentViewController:targetUrl animated:YES completion:nil];

    }}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
   

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack


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


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CPTrace" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CPTrace.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
