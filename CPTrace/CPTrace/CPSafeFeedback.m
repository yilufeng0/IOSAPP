//
//  CPSafeFeedback.m
//  CPTrace
//
//  Created by li xiao on 15-3-27.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeFeedback.h"

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



#pragma feedback imp
//提交反馈
-(IBAction)submitFeedback:(id)sender{
    
}

//返回
-(IBAction)closeFeedback:(id)sender{
    
}



//
@end
