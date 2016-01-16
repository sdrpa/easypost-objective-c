
// Created by Sinisa Drpa, 2015.

#import "EZPPickup.h"
#import "EZPRequest.h"
#import "EZPShipment.h"
#import "EZPRate.h"

#import "AFNetworking.h"

@implementation EZPPickup

/**
 * Retrieve a Pickup from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"pickups/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPPickup success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create a Pickup
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"pickups"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPPickup success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Create this Pickup
 */
- (void)create:(void(^)(NSError *error))completion {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"pickup"];
   [EZPPickup create:parameters completion:^(EZPPickup *pickup, NSError *error) {
      if (error) {
         NSLog(@"Error: %@", [error localizedDescription]);
         NSAssert(false, nil);
         completion(error);
      }
      completion(nil);
   }];
}

/**
 * Purchase this pickup
 */
- (void)buyWithCarrier:(NSString *)carrier service:(NSString *)service completion:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   NSDictionary *parameters = @{@"carrier": carrier,
                                @"service": service};
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"pickups/%@/buy", self.itemId]
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                completion(nil);
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(error);
                             }];
}

/**
 * Create a Pickup
 */
- (void)cancel:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"pickups/%@/cancel", self.itemId]
                          parameters:nil
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                completion(nil);
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
   
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPShipment class]];
   
   [mappingProvider mapFromDictionaryKey:@"rates" toPropertyKey:@"rates"
                          withObjectType:[EZPRate class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPRate class]];
   
   return mappingProvider;
}


@end
