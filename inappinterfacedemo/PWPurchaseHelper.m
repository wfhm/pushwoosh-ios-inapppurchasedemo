//
//  PWPurchaseHelper.m
//  inappinterfacedemo
//
//  Created by pushwoosh on 30/04/2021.
//  Copyright © 2021 pushwoosh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWPurchaseHelper.h"

@interface PWPurchaseHelper() <SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate>

@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) NSArray<SKProduct *> *products;

@end

@implementation PWPurchaseHelper

+ (PWPurchaseHelper*)sharedInstance {
    static PWPurchaseHelper *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

-(BOOL)canMakePayments {
    return [SKPaymentQueue canMakePayments];
}

#pragma mark - validateProduct

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    
    self.request = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark skProduct delegate

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {
    self.products = response.products;
    
    [_delegate PWPurchaseHelperProducts:self.products];
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers)
        NSLog(@"PWPurchaseHelper - Invalid identefier : %@", invalidIdentifier);
    
}

#pragma mark - pay and restore

- (void)payWithIdentefier:(NSString*)identifier
{
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:identifier])
        {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}


-(void)refreshReceipt {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - responding to transaction statuses

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"PWPurchaseHelper - SKPaymentTransactionStatePurchased:  %@",transaction.payment.productIdentifier);
                if ([transaction.payment.productIdentifier isEqualToString:@"test1"]) {
                    //DO SMTH
                }

                [self.delegate PWPurchaseHelperPaymentComplete:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"PWPurchaseHelper - SKPaymentTransactionStateFailed: %@",transaction.error.description);
                [self.delegate PWPurchaseHelperPaymentFailedProductIdentifier:transaction.transactionIdentifier error:transaction.error];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"PWPurchaseHelper - SKPaymentTransactionStateRestored: %@",transaction.payment.productIdentifier);
                if ([transaction.payment.productIdentifier isEqualToString:@"test1"]) {
                   //DO SMTH
                }
                [self.delegate PWPurchaseHelperPaymentComplete:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction inQueue:(SKPaymentQueue *)queue {
    NSLog(@"PWPurchaseHelper - Transaction Failed with error: %@", transaction.error);
    [queue finishTransaction:transaction];
}

- (void)deferredTransaction:(SKPaymentTransaction *)transaction inQueue:(SKPaymentQueue *)queue {
    NSLog(@"PWPurchaseHelper - Transaction Deferred: %@", transaction);
}

#pragma mark - Promoted Purchase

- (BOOL)paymentQueue:(SKPaymentQueue *)queue
shouldAddStorePayment:(SKPayment *)payment
          forProduct:(SKProduct *)product {
    NSLog(@"PWPurchaseHelper - shouldAddStorePayment: %@",product.productIdentifier);
    [self.delegate PWPurchaseHelperCallPromotedPurchase:product.productIdentifier];
    return YES;
}

@end
