//
//  CPSafeNewsMain.m
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeNewsMain.h"

#define NEWSCELLIDENTIFY @"newsCellIdentify"
#define NEWSENTITYNAME @"NewsItem"

@interface CPSafeNewsMain ()

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSManagedObjectContext* managementObjectContext=[[self appDelegate] managedObjectContext];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:NEWSENTITYNAME inManagedObjectContext:managementObjectContext];
    [request setEntity:entity];
    NSSortDescriptor* sort =[NSSortDescriptor sortDescriptorWithKey:@"idNum" ascending:YES];
    NSError* error=nil;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    NSMutableArray* mutableFetchResults=[[managementObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"read fail");
    }
    
    self.newsData=mutableFetchResults;
    [self.tableView reloadData];
    
//    self.newsData = [NSMutableArray arrayWithObjects:@"tes1",@"test2", nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.newsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NEWSCELLIDENTIFY];
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:NEWSCELLIDENTIFY forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NEWSCELLIDENTIFY];
    }
    
    NewsItem* newsItem = (NewsItem*)[self.newsData objectAtIndex:indexPath.row];
    
//    图片根据取出的地址网络获取
//    cell.imageView.image=newsItem.newsImage;
    
    cell.textLabel.text = newsItem.newsTitle;
    cell.detailTextLabel.text = newsItem.newsShowTime;
    NSLog(@"%@",newsItem.newsShowTime);
    return  cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
    
}


//点击后的操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CPSafeWebViewViewController* webView=[[CPSafeWebViewViewController alloc]init];
    
    //取出其中对应的内容URL传递给后端
    NewsItem* newsItem = (NewsItem*)[self.newsData objectAtIndex:indexPath.row];
    
    webView.webURL = newsItem.newsContentUrl;
//    webView.webURL = @"http://www.baidu.com";
    webView.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:webView animated:YES completion:nil];
    
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma openQRCodeReaderViewController

-(IBAction)startOpenQRCodeReader:(id)sender{
    QRCodeReaderViewController* qrcoder = [[QRCodeReaderViewController alloc] init];
    qrcoder.delegate=self;
    [self presentViewController:qrcoder animated:YES completion:nil];
}

#pragma QRCodeReaderViewController delegate


- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result{
    
    //根据扫描得到的结果进行相应界面的跳转
    NSLog(@"%@",result);
    
}

    //cancel按钮点击后的动作
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
