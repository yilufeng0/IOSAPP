//
//  CPSafeCoreData.m
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeCoreData.h"

@implementation CPSafeCoreData
-(CPSafeAppDelegate*)appDelegate{
    return [[UIApplication sharedApplication] delegate];
}

-(NSMutableArray*)fetchNewSFromEntity:(NSString *)entityName{
    NSManagedObjectContext* managementObjectContext=[[self appDelegate] managedObjectContext];
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:managementObjectContext];
    [request setEntity:entity];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResults=[[managementObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"read fail");
    }
    return mutableFetchResults;
}

@end
