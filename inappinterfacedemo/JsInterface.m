//
//  JsInterface.m
//  inappinterfacedemo
//
//  Created by pushwoosh on 30/04/2021.
//  Copyright © 2021 pushwoosh. All rights reserved.
//

#import "JsInterface.h"
#import "PWPurchaseHelper.h"

@implementation JsInterface

- (void)onWebViewStart : NSObject Load:(WKWebView *)webView {
    NSLog(@"JavaScript interface web view start load");
    self.purchaseId = nil;
}

- (void)onWebViewFinishLoad:(WKWebView *)webView {
    NSLog(@"JavaScript interface web view finish load");
}

- (void)onWebViewStartClose:(WKWebView *)webView {
    NSLog(@"JavaScript interface web view start close");
}

- (void)test:(NSString*)str :(PWJavaScriptCallback*)callback {
    NSLog(@"JavaScript interface test called");
    
    [callback executeWithParam:str];
}

- (void)getPurchaseId:(NSString*)str {
    self.purchaseId = str;
}

- (void)makePurchase {
    if (self.purchaseId != nil) {
        [[PWPurchaseHelper sharedInstance] validateProductIdentifiers:[NSArray arrayWithObject: @"test1"]];
        [[PWPurchaseHelper sharedInstance] payWithIdentefier:self.purchaseId];
    }
}

@end
