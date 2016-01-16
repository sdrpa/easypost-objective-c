
// Created by Sinisa Drpa, 2015.

#import "EZPParcel+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPParcel (Synchronous)

/**
 * Retrieve a parcel from its id
 */
+ (EZPParcel *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"parcels/%@", itemId]
         parameters:nil];
}

/**
 * Retrieve parcels
 */
+ (NSArray *)retrieve {
   return [self GET:@"parcels" parameters:nil];
}

/**
 * Create an parcel
 */
+ (EZPParcel *)create:(NSDictionary *)parameters {
   return [self POST:@"parcels" parameters:parameters];
}

@end
