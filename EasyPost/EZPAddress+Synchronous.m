
// Created by Sinisa Drpa, 2015.

#import "EZPAddress+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPAddress (Synchronous)

/**
 * Retrieve an address from its id
 */
+ (EZPAddress *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"addresses/%@", itemId]
         parameters:nil];
}

/**
 * Create an address
 */
+ (EZPAddress *)create:(NSDictionary *)parameters {
   return [self POST:@"addresses" parameters:parameters];
}

/**
 * Create this address
 */
- (void)create {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"address"];
   EZPAddress *object = [EZPAddress create:parameters];
   [self mergeWithObject:object];
}

/**
 * Create and verify an Address
 */
+ (EZPAddress *)createAndVerify:(NSDictionary *)parameters {
   return [self POST:@"addresses/create_and_verify" parameters:parameters rootObject:@"address"];
}

/**
 * Verify an address
 */
- (void)verify:(NSString *)carrier {
   if (!self.itemId) {
      [self create];
   }
   
   NSDictionary *parameters;
   if (carrier) {
      parameters = @{@"carrier": carrier};
   }

   EZPAddress *object = [[self class] GET:[NSString stringWithFormat:@"addresses/%@/verify", self.itemId]
                               parameters:nil
                               rootObject:@"address"];
   [self mergeWithObject:object];
}

@end
