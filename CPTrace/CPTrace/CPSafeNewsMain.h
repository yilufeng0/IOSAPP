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
#import "EGORefreshTableHeaderView.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface CPSafeNewsMain : UITableViewController<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate,EGORefreshTableHeaderDelegate>{
    NSMutableArray* newsData;
    EGORefreshTableHeaderView* _refreshHeaderView;
    BOOL _reloading;
    
}
@property (nonatomic,retain) NSMutableArray* newsData;
@property (strong,nonatomic,retain) NSMutableDictionary* muuserInfo;


-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
@end
