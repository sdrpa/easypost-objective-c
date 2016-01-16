
// Created by Sinisa Drpa, 2015.

#import "EZPRate+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPRate (Synchronous)

/**
 * Retrieve a Rate from its id
 */
+ (EZPRate *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"rates/%@", itemId]
         parameters:nil];
}

@end
