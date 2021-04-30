//
//  JsInterface.h
//  inappinterfacedemo
//
//  Created by pushwoosh on 30/04/2021.
//  Copyright © 2021 pushwoosh. All rights reserved.
//

#import <Pushwoosh/PWInAppManager.h>

#import <Foundation/Foundation.h>

@interface JsInterface : NSObject<PWJavaScriptInterface>

@property (copy, nonatomic) NSString* purchaseId;

@end
