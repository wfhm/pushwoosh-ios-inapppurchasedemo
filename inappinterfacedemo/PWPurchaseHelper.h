//
//  PWPurchaseHelper.h
//  inappinterfacedemo
//
//  Created by pushwoosh on 30/04/2021.
//  Copyright © 2021 pushwoosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol PWPurchaseHelperDelegate <NSObject>

//list of products
-(void)PWPurchaseHelperProducts:(NSArray<SKProduct *>*)products;

//payment complete
-(void)PWPurchaseHelperPaymentComplete:(NSString*)identifier;

//payment failed
-(void)PWPurchaseHelperPaymentFailedProductIdentifier:(NSString*)identifier error:(NSError*)error;

//promoted In-App purchase
-(void)PWPurchaseHelperCallPromotedPurchase:(NSString*)identifier;

@end

@interface PWPurchaseHelper : NSObject

+ (PWPurchaseHelper*)sharedInstance;

@property (nonatomic) id<PWPurchaseHelperDelegate> delegate;

//firstly!!
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers;

//check available payment
- (BOOL)canMakePayments;

//buy purchase
- (void)payWithIdentefier:(NSString*)identifier;

//restore purchase
- (void)refreshReceipt;

@end
