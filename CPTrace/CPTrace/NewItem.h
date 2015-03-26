//
//  NewItem.h
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewItem : NSManagedObject

@property (nonatomic, retain) NSString * newsTitle;
@property (nonatomic, retain) NSString * newsImage;
@property (nonatomic, retain) NSString * newsDescrip;
@property (nonatomic, retain) NSString * newsShowTime;
@property (nonatomic, retain) NSString * newsContentUrl;
@end
