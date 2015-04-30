//
//  CPSafeNetWorkOp.m
//  CPTrace
//
//  Created by li xiao on 15-3-27.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeNetWorkOp.h"
#import "CPSafeAppDelegate.h"
#import "NewsItem.h"

#define webInterface @"http://10.108.158.5:8080/cpServerPro/interface.jsp"
#define NEWSENTITYNAME @"NewsItem"

@interface  CPSafeNetWorkOp()


@end


@implementation CPSafeNetWorkOp


//用于完成反馈信息的提交
-(void)uploadInfo:(NSDictionary *)parameters withURL:(NSString*)targetUrl{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager POST:targetUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//用于新闻条目获取
-(void)getNewsItem:(NSDictionary *)parameters{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager GET:webInterface parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //使用线程对获取的数据进行存储
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败
    }];
}


#pragma coreDataOperate

-(CPSafeAppDelegate*)appDelegate{
    return (CPSafeAppDelegate*)[[UIApplication sharedApplication] delegate];
}


//完成数据向coredata中的插入操作
-(void)InsertNewsJsonIntoCoreData:(NSArray*)webResponse{
    NSError* error=nil;
    NSManagedObjectContext* managedObjectContext=[[self appDelegate] managedObjectContext];
    for (id dic in webResponse) {
        NewsItem* newsItem=[NSEntityDescription insertNewObjectForEntityForName:NEWSENTITYNAME inManagedObjectContext:managedObjectContext];
        newsItem.idNum = [dic objectForKey:@"id"];
        newsItem.newsTitle = [dic objectForKey:@"title"];
        newsItem.newsDescrip=[dic objectForKey:@"abstract"];
        newsItem.newsShowTime =[dic objectForKey:@"showtime"];
        newsItem.newsImage =[dic objectForKey:@"smallUrl"];
        newsItem.newsContentUrl=[dic objectForKey:@"contentUrl"];
        [managedObjectContext save:&error];
    }
    
}



#pragma 获取网络状态
+(Boolean) getNetworkStatus{
    Boolean result = false;
  
    
    return result;
}


@end
