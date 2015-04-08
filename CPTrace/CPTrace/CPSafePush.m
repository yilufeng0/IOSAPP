//
//  CPSafePush.m
//  CPTrace
//
//  Created by li xiao on 15-4-3.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafePush.h"
#import "UMessage.h"


@implementation CPSafePush



//设置自动屏幕旋转
-(BOOL)shouldAutorotate
{
    return NO;
}

//屏幕支持方向（Portrait：竖向）
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
