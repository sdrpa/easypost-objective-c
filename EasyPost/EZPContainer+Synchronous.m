
// Created by Sinisa Drpa, 2015.

#import "EZPContainer+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPContainer (Synchronous)

/**
 * Retrieve a Container from its id or reference
 */
+ (EZPContainer *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"containers/%@", itemId]
         parameters:nil];
}

/**
 * Create a Container
 */
+ (EZPContainer *)create:(NSDictionary *)parameters {
   return [self POST:@"containers" parameters:parameters];
}

@end
