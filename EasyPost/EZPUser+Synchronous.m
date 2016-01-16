
// Created by Sinisa Drpa, 2015.

#import "EZPUser+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPUser (Synchronous)

/**
 * Retrieve a User from its id
 * REQUIRES kLiveSecretAPIKey
 */
+ (EZPUser *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"users/%@", itemId]
         parameters:nil];
}

/**
 * Retrieve users
 * REQUIRES kLiveSecretAPIKey
 */
+ (NSArray *)retrieveUsers {
   return [self GET:@"users" parameters:nil];
}

/**
 * Create a child user for the account associated with the api_key specified
 * REQUIRES kLiveSecretAPIKey
 */
+ (EZPUser *)create:(NSDictionary *)parameters {
   return [self POST:@"pickups" parameters:parameters];
}

/**
 * Update the User associated with the api_key specified
 * REQUIRES kLiveSecretAPIKey
 */
- (void)update:(NSDictionary *)parameters {
   NSParameterAssert(self.itemId);
   EZPUser *object = [[self class] PUT:[NSString stringWithFormat:@"users/%@", self.itemId]
          parameters:@{@"user": parameters}];
   [self mergeWithObject:object];
}

@end
