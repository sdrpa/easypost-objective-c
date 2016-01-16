
// Created by Sinisa Drpa, 2015.

#import "EZPCarrierAccount+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPCarrierAccount (Synchronous)

/**
 * REQUIRES kLiveSecretAPIKey
 */
+ (NSArray *)list {
   return [self GET:@"carrier_accounts" parameters:nil];
}

/**
 * Retrieve a CarrierAccount from its id
 * REQUIRES kLiveSecretAPIKey
 */
+ (EZPCarrierAccount *)retrieve:(NSString *)carrierAccountId {
   return nil;
}

/**
 * Create a CarrierAccount
 * REQUIRES kLiveSecretAPIKey
 */
+ (EZPCarrierAccount *)create:(NSDictionary *)parameters {
   return nil;
}

/**
 * Remove this CarrierAccount from your account
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)delete:(NSString *)carrierAccountId {
}

/**
 * Update this CarrierAccount
 * REQUIRES kLiveSecretAPIKey
 */
+ (EZPCarrierAccount *)update:(NSString *)itemId parameters:(NSDictionary *)parameters {
   return nil;
}

@end
