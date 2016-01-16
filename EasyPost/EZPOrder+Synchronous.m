
// Created by Sinisa Drpa, 2015.

#import "EZPOrder+Synchronous.h"
#import "EZPObject+Synchronous.h"
#import "EZPRate.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPOrder (Synchronous)

/**
 * Retrieve an Order from its id or reference
 */
+ (EZPOrder *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"orders/%@", itemId]
         parameters:nil];
}

/**
 * Create an Order
 */
+ (EZPOrder *)create:(NSDictionary *)parameters {
   return [self POST:@"orders" parameters:parameters];
}

/**
 * Create this Order
 */
- (void)create {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"order"];
   EZPOrder *object = [EZPOrder create:parameters];
   [self mergeWithObject:object];
}

/**
 * Purchase a label for this shipment with the given rate
 */
- (void)buyWithRate:(EZPRate *)rate {
   [self buy:rate.carrier service:rate.service];
}

/**
 * Purchase the shipments within this order with a carrier and service
 */
- (void)buy:(NSString *)carrier service:(NSString *)service {
   NSParameterAssert(self.itemId);
   NSParameterAssert(carrier);
   NSParameterAssert(service);
   EZPOrder *object = [[self class] POST:[NSString stringWithFormat:@"orders/%@/buy", self.itemId]
                             parameters:@{@"carrier": carrier, @"service": service}];
   [self mergeWithObject:object];
}

@end
