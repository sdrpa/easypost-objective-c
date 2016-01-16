
// Created by Sinisa Drpa, 2015.

#import "EZPBatch.h"
#import "EZPShipment.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPBatch

/**
 * Retrieve a Batch from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"batches/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPBatch success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create a Batch
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"batches"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPBatch success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Add shipments to the batch
 */
- (void)addShipmentsWithShipments:(NSArray *)shipments completion:(void(^)(NSError *error))completion {
   [self addShipments:[self shipmentIdsWithShipments:shipments] completion:completion];
}

/**
 * Add shipments to the batch
 */
- (void)addShipments:(NSArray *)shipmentIds completion:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   __weak EZPBatch *weakSelf = self;
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"batches/%@/add_shipments", self.itemId]
                          parameters:[self parametersWithShipmentIds:shipmentIds]
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPBatch success:responseObject completion:^(EZPBatch *batch, NSError *error) {
                                   if (error) {
                                      NSLog(@"Error userInfo: %@", [error userInfo]);
                                      NSAssert(false, [error localizedDescription]);
                                   }
                                   [weakSelf mergeWithObject:batch];
                                   completion(nil);
                                }];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(error);
                             }];
}

/**
 * Remove shipments from the batch
 */
- (void)removeShipmentsWithShipments:(NSArray *)shipments completion:(void(^)(NSError *error))completion {
   [self removeShipments:[self shipmentIdsWithShipments:shipments] completion:completion];
}

/**
 * Remove shipments from the batch
 */
- (void)removeShipments:(NSArray *)shipmentIds completion:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   __weak EZPBatch *weakSelf = self;
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"batches/%@/remove_shipments", self.itemId]
                          parameters:[self parametersWithShipmentIds:shipmentIds]
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPBatch success:responseObject completion:^(EZPBatch *batch, NSError *error) {
                                   if (error) {
                                      NSLog(@"Error userInfo: %@", [error userInfo]);
                                      NSAssert(false, [error localizedDescription]);
                                   }
                                   [weakSelf mergeWithObject:batch];
                                   completion(nil);
                                }];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(error);
                             }];
}

- (NSArray *)shipmentIdsWithShipments:(NSArray *)shipments {
   NSMutableArray *shipmentIds = [NSMutableArray array];
   for (NSString *shipmentId in shipmentIds) {
      [shipmentIds addObject:shipmentId];
   }
   return [shipmentIds copy];
}

- (NSDictionary *)parametersWithShipmentIds:(NSArray *)shipmentIds {
   NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
   for (NSUInteger i=0; i<[shipmentIds count]; i++) {
      NSString *shipmentId = shipmentIds[i];
      parameters[[NSString stringWithFormat:@"shipments[%li][id]", i]] = shipmentId;
   }
   return [parameters copy];
}

#pragma mark

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
   
   return mappingProvider;
}

@end
