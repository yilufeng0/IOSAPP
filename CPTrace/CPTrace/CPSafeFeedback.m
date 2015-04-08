//
//  CPSafeFeedback.m
//  CPTrace
//
//  Created by li xiao on 15-3-27.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeFeedback.h"
#import "AFNetworking.h"
#import "CPSafeAppDelegate.h"


#define webInterface @"http://10.108.158.5:8080/cpServerPro/interface.jsp"


@interface CPSafeFeedback ()
@property (weak, nonatomic) IBOutlet UITextField *tfFeedback;

@end

@implementation CPSafeFeedback

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
    
    //在此注册消息
    [self registeNotification];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma notificationOp

-(void)registeNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tfFeedback resignFirstResponder];
    
}

//键盘显示
-(void) keyboardWillShow:(NSNotification*) notification{
    [UIView beginAnimations:@"keyboardWillShow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect rect=self.view.frame;
    rect.origin.y =-40;
    self.view.frame=rect;
    [UIView commitAnimations];
}

//键盘隐藏
-(void) keyboardWillHide:(NSNotification*)notification{
    [UIView beginAnimations:@"keyboardWillHide" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect rect=self.view.frame;
    rect.origin.y =0;
    self.view.frame=rect;
    [UIView commitAnimations];
    
}

#pragma after submit
-(void)popViewAlter:(NSString*)message{
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:alertView repeats:NO];
    [alertView show];
}

-(void)timerAction:(NSTimer*)timer{
    UIAlertView* alterView = (UIAlertView*)[timer userInfo];
    [alterView dismissWithClickedButtonIndex:0 animated:YES];
    
}

#pragma feedback imp
//提交反馈(Done)
-(IBAction)submitFeedback:(id)sender{
    
    NSMutableDictionary* parameter = [NSMutableDictionary new];
    [parameter setValue:@"feedback" forKey:@"requestType"];
    [parameter setValue:self.tfFeedback.text forKey:@"content_str"];
    NSString* deviceToken = [[CPSafeAppDelegate alloc] init].deviceTokenReg;
    [parameter setValue:deviceToken forKey:@"uuid"];
    
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager POST:webInterface parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self popViewAlter:@"提交成功!"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self popViewAlter:@"提交失败!"];
    }];
    
}

//返回(give up)
-(IBAction)closeFeedback:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//
@end
