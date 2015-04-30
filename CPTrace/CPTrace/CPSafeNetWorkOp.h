//
//  CPSafeNetWorkOp.h
//  CPTrace
//
//  Created by li xiao on 15-3-27.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CPSafeNetWorkOp : NSObject
-(void)uploadInfo:(NSDictionary*)parameters withURL:(NSString*)targetUrl;
-(void)getNewsItem:(NSDictionary*)parameters;

+(Boolean) getNetworkStatus;
@end
