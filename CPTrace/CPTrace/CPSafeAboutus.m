//
//  CPSafeAboutus.m
//  CPTrace
//
//  Created by li xiao on 15-3-27.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeAboutus.h"

@interface CPSafeAboutus ()

@end

@implementation CPSafeAboutus

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitAboutUs:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma aboutUs imp

@end
