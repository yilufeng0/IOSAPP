//
//  CPSafeCoreData.h
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPSafeAppDelegate.h"


@interface CPSafeCoreData : NSObject
-(NSMutableArray*)fetchNewSFromEntity:(NSString*)entityName;
@end
