//
//  CPSafeViewController.m
//  CPTrace
//
//  Created by li xiao on 15-3-25.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeViewController.h"
#import "NewsItem.h"
#import "CPSafeAppDelegate.h"

@interface CPSafeViewController ()

@end

@implementation CPSafeViewController

@synthesize data;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)InsertIntoCD:(id)sender {
    
    //CreData数据插入实例
    [self CoreDataInsertData];
}


#pragma CoreData 操作样例

//插入数据
-(void)CoreDataInsertData{
    NSError* error=nil;
    NSManagedObjectContext* managedObjectContext=[(CPSafeAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NewsItem *news=(NewsItem*)[NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:managedObjectContext];
    news.idNum=[NSNumber numberWithInteger:1];
    news.newsTitle=@"title";
    news.newsShowTime=@"time";
    news.newsImage = @"image";
    news.newsDescrip=@"desp";
    news.newsContentUrl=@"Contenturl";
    bool result=[managedObjectContext save:&error];
    if (result) {
        NSLog(@"yes");
    }else{
        NSLog(@"No");
    }

}


-(void)QueryCoreData{
    NSError* error=nil;
    NSManagedObjectContext* managedObjectContext=[(CPSafeAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest* request=[[NSFetchRequest alloc]init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor* sort=[NSSortDescriptor sortDescriptorWithKey:@"ID" ascending:NO];
    [request setEntity:entity];
    request.sortDescriptors = [NSArray arrayWithObjects:sort, nil];
    NSMutableArray* fetchResult=[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (fetchResult ==nil) {
        
    }
    
    self.data=fetchResult;
    
}

-(void)DeleteCoreDataWithIndex:(NSInteger)index{
    NSError* error=nil;
    NSManagedObjectContext* managedObjectContext=[(CPSafeAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSManagedObject* managedObject =[self.data objectAtIndex:index];
    [managedObjectContext deleteObject:managedObject];
    if (![managedObjectContext save:&error]) {
        NSLog(@"error");
    }
    
}

@end
