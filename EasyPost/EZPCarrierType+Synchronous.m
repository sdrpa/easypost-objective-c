
// Created by Sinisa Drpa, 2015.

#import "EZPCarrierType+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPCarrierType (Synchronous)

/**
 * Get list of carrier types
 * REQUIRES kLiveSecretAPIKey
 */
+ (NSArray *)list {
   return [self GET:@"carrier_types" parameters:nil];
}

@end
