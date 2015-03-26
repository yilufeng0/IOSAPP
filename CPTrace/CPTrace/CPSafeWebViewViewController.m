//
//  CPSafeWebViewViewController.m
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeWebViewViewController.h"

@interface CPSafeWebViewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic)UIActivityIndicatorView* activityIndicator;

@end

@implementation CPSafeWebViewViewController

@synthesize webURL;
@synthesize activityIndicator;


//刷新 重新加载页面
-(IBAction)refreshPage:(id)sender{
    [self loadWebPage];
}


//实现页面加载
-(void)loadWebPage{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:webURL]];
    [self.webView loadRequest:request];

}

//返回按钮操作
- (IBAction)BackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//视图出现是进行页面加载
-(void)viewWillAppear:(BOOL)animated{
    [self loadWebPage];
}

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
    activityIndicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
    
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{

    [activityIndicator startAnimating];
    //NSLog(@"start to load web");
     
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicator stopAnimating];
    
    //NSLog(@"finish load web");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [activityIndicator stopAnimating];
    
    //NSLog(@"load error");
}




@end
