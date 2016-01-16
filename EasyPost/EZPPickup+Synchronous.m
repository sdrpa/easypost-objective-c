
// Created by Sinisa Drpa, 2015.

#import "EZPPickup+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPPickup (Synchronous)

/**
 * Retrieve a Pickup from its id
 */
+ (EZPPickup *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"pickups/%@", itemId]
         parameters:nil];
}

/**
 * Create a Pickup
 */
+ (EZPPickup *)create:(NSDictionary *)parameters {
   return [self POST:@"pickups" parameters:parameters];
}

/**
 * Create this Pickup
 */
- (void)create {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"pickup"];
   EZPPickup *object = [EZPPickup create:parameters];
   [self mergeWithObject:object];
}

/**
 * Purchase this pickup
 */
- (void)buyWithCarrier:(NSString *)carrier service:(NSString *)service {
   NSParameterAssert(self.itemId);
   NSParameterAssert(carrier);
   NSParameterAssert(service);
   EZPPickup *object = [[self class] POST:[NSString stringWithFormat:@"orders/%@/buy", self.itemId]
                               parameters:@{@"carrier": carrier, @"service": service}];
   [self mergeWithObject:object];
}

- (void)cancel {
   NSParameterAssert(self.itemId);
   EZPPickup *object = [[self class] POST:[NSString stringWithFormat:@"pickups/%@/cancel", self.itemId]
                               parameters:nil];
   [self mergeWithObject:object];
}

@end
