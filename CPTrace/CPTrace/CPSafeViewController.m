//
//  CPSafeViewController.m
//  CPTrace
//
//  Created by li xiao on 15-3-25.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeViewController.h"
#import "NewItem.h"
#import "CPSafeAppDelegate.h"

@interface CPSafeViewController ()

@end

@implementation CPSafeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)InsertIntoCD:(id)sender {
    
    NSError* error=nil;
    NSManagedObjectContext* managedObjectContext=[(CPSafeAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NewItem *news=(NewItem*)[NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:managedObjectContext];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
