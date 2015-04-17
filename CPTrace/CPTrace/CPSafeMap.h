//
//  CPSafeMap.h
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSLocateView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <QuartzCore/QuartzCore.h>

@interface CPSafeMap : UIViewController<UIActionSheetDelegate>

@property(strong) CLLocation *currentLocation;

@end