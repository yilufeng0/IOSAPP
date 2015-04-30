//
//  CPSafeTraceResult.m
//  CPTrace
//
//  Created by li xiao on 15-4-29.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeTraceResult.h"

@interface CPSafeTraceResult ()
@property (weak, nonatomic) IBOutlet UITextField *entNum;
@property (weak, nonatomic) IBOutlet UITextField *produceTime;
@property (weak, nonatomic) IBOutlet UITextField *productLine;
@property (weak, nonatomic) IBOutlet UITextField *productType;

@end

@implementation CPSafeTraceResult
@synthesize traceUrl;



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString* traceId = [traceUrl substringWithRange:NSMakeRange([traceUrl rangeOfString:@"TraceID"].location+8, 17)];
    NSDictionary* result = [self traceIdOp:traceId];
    self.entNum.text = [result objectForKey:@"ent"];
    self.produceTime.text = [NSString stringWithFormat:@"%@-%@-%@",[result objectForKey:@"year"],[result objectForKey:@"month"],[result objectForKey:@"day"]];
    
    self.productLine.text = [result objectForKey:@"line"];
    self.productType.text = [result objectForKey:@"type"];

}

-(NSDictionary*) traceIdOp:(NSString*) traceId {
    NSMutableDictionary* result = [NSMutableDictionary new];
    [result setObject:[traceId substringWithRange:NSMakeRange(0, 4)] forKey:@"entNum"];
    [result setObject:[traceId substringWithRange:NSMakeRange(4, 4)] forKey:@"year"];
    [result setObject:[traceId substringWithRange:NSMakeRange(8, 2)] forKey:@"month"];
    [result setObject:[traceId substringWithRange:NSMakeRange(10, 2)] forKey:@"day"];
    [result setObject:[traceId substringWithRange:NSMakeRange(12, 2)] forKey:@"line"];
    [result setObject:[traceId substringWithRange:NSMakeRange(14, 3)] forKey:@"type"];
    
    return result;
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
