//
//  CPSafeNewsMain.m
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeNewsMain.h"
#import "AFNetworking.h"
#import "CPSafeTraceResult.h"

#define NEWSCELLIDENTIFY @"newsCellIdentify"
#define NEWSENTITYNAME @"NewsItem"
#define webInterface @"http://103.244.82.219:8080/cpServerPro/interface.jsp"
#define NEWSENTITYNAME @"NewsItem"


@interface CPSafeNewsMain ()
{
    Boolean networkFlag;

}

@property (strong, readwrite, nonatomic) NSString* qrCodeResult;

@end

@implementation CPSafeNewsMain

@synthesize newsData;


-(CPSafeAppDelegate*)appDelegate{
    return (CPSafeAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma inset data into coredata

//实现网络获取数据(json格式)
-(void)downloadDataFromServer:(NSDictionary*)parameters
{
    if (networkFlag) {
        return;
    }
    
    networkFlag = true;
    
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager GET:webInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //使用线程对获取的数据进行存储(存入coredata)
        [self InsertNewsJsonIntoCoreData:responseObject];
        [self loadDataFromCoreData];
        networkFlag = false;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
        networkFlag = false;
        
        
#pragma 删除数据条目
       NSManagedObjectContext* managedObjectContext=[[self appDelegate] managedObjectContext];
        NSEntityDescription* description = [NSEntityDescription entityForName:NEWSENTITYNAME inManagedObjectContext:managedObjectContext];
        NSFetchRequest* request =[NSFetchRequest new];
        [request setEntity:description];
        for (NSManagedObject* obj in newsData) {
            [managedObjectContext deleteObject:obj];
            
        }
        [self loadDataFromCoreData];

    }];
}


//将从server获取的数据(json格式)存入coredata中
-(void)InsertNewsJsonIntoCoreData:(id)webResponse{
    NSError* error=nil;
    NSManagedObjectContext* managedObjectContext=[[self appDelegate] managedObjectContext];
    NSLog(@"server data：%@",webResponse);
    for (id dic in webResponse)
    {
        NewsItem* newsItem=[NSEntityDescription insertNewObjectForEntityForName:NEWSENTITYNAME inManagedObjectContext:managedObjectContext];
        newsItem.idNum = [dic objectForKey:@"id"];
        newsItem.newsTitle = [dic objectForKey:@"title"];
        newsItem.newsDescrip=[dic objectForKey:@"abstract"];
        newsItem.newsShowTime =[dic objectForKey:@"showtime"];
        newsItem.newsImage =[dic objectForKey:@"smallUrl"];
        newsItem.newsContentUrl=[dic objectForKey:@"contentUrl"];
        [managedObjectContext save:&error];
        NSLog(@"insert core data error:%@",error);
    }
    
}


#pragma load data from core data
-(void)loadDataFromCoreData{
    NSManagedObjectContext* managementObjectContext=[[self appDelegate] managedObjectContext];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:NEWSENTITYNAME inManagedObjectContext:managementObjectContext];
    [request setEntity:entity];
    NSSortDescriptor* sort =[NSSortDescriptor sortDescriptorWithKey:@"idNum" ascending:NO];
    NSError* error=nil;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSMutableArray* mutableFetchResults=[[managementObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"read fail");
    }
    if ([mutableFetchResults count]) {
        maxId = [[(NewsItem*)[mutableFetchResults objectAtIndex:0]  idNum] intValue];
    }else{
        maxId = 0;
    }
    self.newsData=mutableFetchResults;
    [self.tableView reloadData];

}


#pragma view load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    networkFlag = false;
    
    self.tableView.tableFooterView = [UIView new];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
        
        
    }
    
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self loadDataFromCoreData];
    
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:@"newsitem" forKey:@"requestType"];
    [parameters setObject:[NSNumber numberWithInt:maxId] forKey:@"id"];
    NSLog(@"max id in view did load:%d",maxId);
    [self downloadDataFromServer:parameters];
    
    
    
 
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsData count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //注册class用于cell设置reuseIdentifier
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NEWSCELLIDENTIFY];
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:NEWSCELLIDENTIFY forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NEWSCELLIDENTIFY];
    }
    
    NewsItem* newsItem = (NewsItem*)[self.newsData objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:newsItem.newsImage] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.textLabel.text = newsItem.newsTitle;
    cell.textLabel.textColor = [UIColor blackColor];
    NSString* showTimeText = [NSString stringWithFormat:@"%@",newsItem.newsShowTime];
//    NSLog(@"%d:%@",indexPath.row, showTimeText);
    cell.detailTextLabel.text = showTimeText;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    return  cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
    
}


//点击某个cell后的操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPSafeWebViewViewController* webView=[[CPSafeWebViewViewController alloc]init];
    
    //取出其中对应的内容URL传递给后端
    NewsItem* newsItem = (NewsItem*)[self.newsData objectAtIndex:indexPath.row];
    
    webView.webURL = newsItem.newsContentUrl;
    webView.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:webView animated:YES completion:nil];
    
}




- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}






#pragma UIScrollViewDelegateMethods  //下拉刷新

-(void)reloadTableViewDataSource{
    //网络更新
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:@"newsitem" forKey:@"requestType"];
    [parameters setObject:[NSNumber numberWithInt:maxId] forKey:@"id"];
    [self downloadDataFromServer:parameters];
    
    _reloading = YES;
}

-(void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}


#pragma UIScrollViewDelegateMethods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSMutableDictionary* parameters = [NSMutableDictionary new];
    [parameters setObject:@"newsitem" forKey:@"requestType"];
    [parameters setObject:[NSNumber numberWithInt:maxId] forKey:@"id"];
    [self downloadDataFromServer:parameters];

    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}

-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    
    return [NSDate date];
}



#pragma openQRCodeReaderViewController //二维码扫描功能

-(IBAction)startOpenQRCodeReader:(id)sender{
    QRCodeReaderViewController* qrcoder = [[QRCodeReaderViewController alloc] init];
    qrcoder.delegate=self;
    [self presentViewController:qrcoder animated:YES completion:nil];
}

#pragma QRCodeReaderViewController delegate


- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    
    self.qrCodeResult = result;
//    NSLog(@"%@",self.qrCodeResult);
    //根据扫描得到的结果进行相应界面的跳转
    NSRange range;
    range = [result rangeOfString:@"TraceID"];
    if (range.location != NSNotFound) {
        [self doWithNetworkStatus];
    }else{
        
        //不是目标url
    }
    
    
    
}

//cancel按钮点击后的动作
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//判断网络连接状态

-(void) doWithNetworkStatus{
    
    
    
        [[AFNetworkReachabilityManager  sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        CPSafeWebViewViewController* traceWebView = [CPSafeWebViewViewController new];
        CPSafeTraceResult* offLineShow = [CPSafeTraceResult new];
        switch (status) {
            case 1:
            case 2:
                
                traceWebView.webURL = [self qrCodeResult];
                [self presentViewController:traceWebView animated:YES completion:nil];
                break;
                
            default:
                offLineShow.traceUrl = [self qrCodeResult];
                [self presentViewController:offLineShow animated:YES completion:nil];
                break;
        }
    }];

}


@end
