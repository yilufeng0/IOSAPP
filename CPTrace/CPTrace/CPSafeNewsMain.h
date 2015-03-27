//
//  CPSafeNewsMain.h
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"
//#import "CPSafeCoreData.h"
#import "CPSafeAppDelegate.h"
#import "CPSafeWebViewViewController.h"
#import "QRCodeReaderViewController.h"

@interface CPSafeNewsMain : UITableViewController<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate>{
    NSMutableArray* newsData;
    
}
@property (nonatomic,retain) NSMutableArray* newsData;
@end
