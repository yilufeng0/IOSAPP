//
//  CPSafeSetting.m
//  CPTrace
//
//  Created by li xiao on 15-4-7.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeSetting.h"
#import "CPSafeAboutus.h"
#import "CPSafeFeedback.h"


@interface CPSafeSetting ()

@end

@implementation CPSafeSetting

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma setting item action

- (IBAction)aboutUs:(id)sender {
    CPSafeAboutus* aboutus= [CPSafeAboutus new];
    [self presentViewController:aboutus animated:YES completion:nil];
}
- (IBAction)feedback:(id)sender {
   // CPSafeFeedback* feedback = [CPSafeFeedback new];
   // [self presentViewController:feedback animated:YES completion:nil];
    //CPSafeFeedback* feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"123"];
   // [self presentViewController:feedback animated:YES completion:nil];
    CPSafeFeedback* feedback = [[CPSafeFeedback alloc]initWithNibName:@"CPSafeFeedback" bundle:nil];
    [self presentViewController:feedback animated:YES completion:nil];
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

@end
