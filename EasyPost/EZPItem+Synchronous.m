
// Created by Sinisa Drpa, 2015.

#import "EZPItem+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPItem (Synchronous)

/**
 * Retrieve a Item from a custom reference
 */
+ (EZPItem *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"items/%@", itemId]
         parameters:nil];
}

/**
 * Create an Item
 */
+ (EZPItem *)create:(NSDictionary *)parameters {
   return [self POST:@"items" parameters:parameters];
}

/**
 * Retrieve a Item from a custom reference
 */
+ (EZPItem *)retrieve:(NSString *)name value:(NSString *)value {
   NSParameterAssert(name);
   NSParameterAssert(value);
   return [self GET:[NSString stringWithFormat:@"items/retrieve_reference/?%@=%@", name, value]
         parameters:nil];
}

@end
