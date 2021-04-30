//
//  ViewController.m
//  inappinterfacedemo
//
//  Created by pushwoosh on 30/04/2021.
//  Copyright © 2021 pushwoosh. All rights reserved.
//

#import "ViewController.h"
#import "PWPurchaseHelper.h"
#import <Pushwoosh/PWInAppManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(makePurchase:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Make purchase" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.blueColor];
    [button setFrame:CGRectMake(80.0, 210.0, 160.0, 40.0)];
    [self.view addSubview:button];
}

- (void) makePurchase: (UIButton*)sender {
    if ([[PWPurchaseHelper sharedInstance] canMakePayments]){
        [[PWInAppManager sharedManager] postEvent:@"makePurchase" withAttributes:nil];
    }
}

@end
