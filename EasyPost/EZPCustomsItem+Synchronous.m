
// Created by Sinisa Drpa, 2015.

#import "EZPCustomsItem+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPCustomsItem (Synchronous)

/**
 * Retrieve a CustomsItem from its id
 */
+ (EZPCustomsItem *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"customs_items/%@", itemId]
         parameters:nil];
}

/**
 * Create a CustomsItem
 */
+ (EZPCustomsItem *)create:(NSDictionary *)parameters {
   return [self POST:@"customs_items" parameters:parameters];
}

@end
