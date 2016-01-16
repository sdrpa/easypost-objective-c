
// Created by Sinisa Drpa, 2015.

#import "EZPCustomsInfo+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPCustomsInfo (Synchronous)

/**
 * Retrieve a CustomsInfo from its id
 */
+ (EZPCustomsInfo *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"customs_infos/%@", itemId]
         parameters:nil];
}

/**
 * Create a CustomsInfo
 */
+ (EZPCustomsInfo *)create:(NSDictionary *)parameters {
   return [self POST:@"customs_infos" parameters:parameters];
}

@end
