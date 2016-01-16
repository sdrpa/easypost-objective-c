
// Created by Sinisa Drpa, 2015.

#import "EZPOrder.h"
#import "EZPRequest.h"
#import "EZPRate.h"
#import "EZPShipment.h"
#import "EZPContainer.h"
#import "EZPItem.h"

#import "AFNetworking.h"

@implementation EZPOrder

/**
 * Retrieve an Order from its id or reference
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"orders/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPOrder success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create an Order
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"orders"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPOrder success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Create this Order
 */
- (void)create:(void(^)(NSError *error))completion {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"order"];
   __weak EZPOrder *weakSelf = self;
   [EZPOrder create:parameters completion:^(EZPOrder *order, NSError *error) {
      if (error) {
         NSLog(@"Error: %@", [error localizedDescription]);
         NSAssert(false, nil);
         completion(error);
      }
      [weakSelf mergeWithObject:order];
   }];
}

/**
 * Purchase a label for this shipment with the given rate
 */
- (void)buyWithRate:(EZPRate *)rate completion:(void(^)(NSError *error))completion {
   [self buy:rate.carrier service:rate.service completion:completion];
}

/**
 * Purchase the shipments within this order with a carrier and service
 */
- (void)buy:(NSString *)carrier service:(NSString *)service completion:(void(^)(NSError *error))completion {
   NSParameterAssert(self.itemId);
   NSParameterAssert(carrier);
   NSParameterAssert(service);
   __weak EZPOrder *weakSelf = self;
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"orders/%@/buy", self.itemId]
                          parameters:@{@"carrier": carrier, @"service": service}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPOrder success:responseObject completion:^(EZPOrder *order, NSError *error) {
                                   if (error) {
                                      NSLog(@"Error userInfo: %@", [error userInfo]);
                                      NSAssert(false, [error localizedDescription]);
                                   }
                                   [weakSelf mergeWithObject:order];
                                   completion(nil);
                                }];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(error);
                             }];
}

+ (InCodeMappingProvider *)mappingProvider {
   InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
   NSDictionary *propertyMap = [EZPObject propertyMap];
   for (NSString *key in propertyMap) {
      [mappingProvider mapFromDictionaryKey:key toPropertyKey:propertyMap[key] forClass:[self class]];
   }
   
   [mappingProvider mapFromDictionaryKey:@"shipments" toPropertyKey:@"shipments"
                          withObjectType:[EZPShipment class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPShipment class]];
   
   [mappingProvider mapFromDictionaryKey:@"rates" toPropertyKey:@"rates"
                          withObjectType:[EZPRate class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPRate class]];
   
   [mappingProvider mapFromDictionaryKey:@"containers" toPropertyKey:@"containers"
                          withObjectType:[EZPContainer class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPContainer class]];
   
   [mappingProvider mapFromDictionaryKey:@"items" toPropertyKey:@"items"
                          withObjectType:[EZPItem class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPItem class]];
   
   return mappingProvider;
}

@end
