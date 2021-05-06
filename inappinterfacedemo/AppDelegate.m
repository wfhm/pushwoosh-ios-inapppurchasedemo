//
//  AppDelegate.m
//  inappinterfacedemo
//
//  Created by pushwoosh on 30/04/2021.
//  Copyright © 2021 pushwoosh. All rights reserved.
//

#import "AppDelegate.h"
#import "JsInterface.h"
#import <Pushwoosh/Pushwoosh.h>
#import <Pushwoosh/PWInAppManager.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   //-----------PUSHWOOSH PART-----------

    // set custom delegate for push handling, in our case AppDelegate
    [Pushwoosh sharedInstance].delegate = self;

    //register for push notifications!
    [[Pushwoosh sharedInstance] registerForPushNotifications];
    [[PWInAppManager sharedManager] addJavascriptInterface:[JsInterface new] withName:@"PurchaseInterface"];
    
    return YES;
}

//this is for iOS < 10 and for silent push notifications
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
        [[Pushwoosh sharedInstance] handlePushReceived:userInfo];
        completionHandler(UIBackgroundFetchResultNoData);
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
