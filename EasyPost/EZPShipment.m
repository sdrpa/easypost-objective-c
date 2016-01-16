
// Created by Sinisa Drpa, 2015.

#import "EZPShipment.h"
#import "EZPRate.h"
#import "EZPFee.h"
#import "EZPForm.h"
#import "EZPCarrierAccount.h"
#import "EZPRequest.h"
#import "NSDictionaryUtility.h"

#import "EZPCustomsInfo.h"
#import "EZPCustomsItem.h"

#import "AFNetworking.h"

@implementation EZPShipment

/**
 * Get list of shipments
 */
+ (void)list:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] GET:@"shipments"
                         parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Retrieve a Shipment from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"shipments/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create a Shipment
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"shipments"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPShipment success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Create this Shipment
 */
- (void)create:(void(^)(NSError *error))completion {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"shipment"];
   [EZPShipment create:parameters completion:^(EZPShipment *shipment, NSError *error) {
      if (error) {
         NSLog(@"Error: %@", [error localizedDescription]);
         NSAssert(false, nil);
      }
      [self mergeWithObject:shipment];

      completion(error);
   }];
}

/**
 * Populate the rates property for this shipment
 */
- (void)fetchRates:(void(^)(NSError *error))completion {
   if (self.itemId) {
      [self fetchRates:self.itemId completion:^(NSError *error) {
         if (error) {
            completion(error);
         } else {
            completion(nil);
         }
      }];
      
      return;
   }
   
   [self create:^(NSError *error) {
      if (error) {
         completion(error);
      }
      [self fetchRates:self.itemId completion:^(NSError *error) {
         if (error) {
            completion(error);
         } else {
            completion(nil);
         }
      }];
   }];
}

- (void)fetchRates:(NSString *)itemId completion:(void(^)(NSError *error))completion {
   NSAssert(itemId, @"self.itemId == nil");
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"shipments/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                  if (error) {
                                     NSLog(@"Error userInfo: %@", [error userInfo]);
                                     NSAssert(false, [error localizedDescription]);
                                  }
                                  [weakSelf mergeWithObject:shipment];
                                  completion(nil);
                               }];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(error);
                            }];
}

- (void)buyWithRate:(EZPRate *)rate completion:(void(^)(NSError *error))completion {
   [self buy:rate.itemId completion:completion];
}

/**
 * Purchase a label for this shipment with the given rate
 */
- (void)buy:(NSString *)rateId completion:(void(^)(NSError *error))completion {
   NSParameterAssert(self.itemId);
   NSParameterAssert(rateId);
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"shipments/%@/buy", self.itemId]
                          parameters:@{@"rate": @{@"id": rateId}}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                   if (error) {
                                      NSLog(@"Error userInfo: %@", [error userInfo]);
                                      NSAssert(false, [error localizedDescription]);
                                   }
                                   [weakSelf mergeWithObject:shipment];
                                   completion(nil);
                                }];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(error);
                             }];
}

/**
 * Insure shipment for the given amount
 */
- (void)insure:(double)amount completion:(void(^)(NSError *error))completion {
   NSParameterAssert(self.itemId);
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] POST:[NSString stringWithFormat:@"shipments/%@/insure", self.itemId]
                          parameters:@{@"amount": [NSString stringWithFormat:@"%f", amount]}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                   if (error) {
                                      NSLog(@"Error userInfo: %@", [error userInfo]);
                                      NSAssert(false, [error localizedDescription]);
                                   }
                                   [weakSelf mergeWithObject:shipment];
                                   completion(nil);
                                }];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(error);
                             }];
}

/**
 * Send a refund request to the carrier the shipment was purchased from
 */
- (void)refund:(void(^)(NSError *error))completion {
   NSParameterAssert(self.itemId);
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"shipments/%@/refund", self.itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                  if (error) {
                                     NSLog(@"Error userInfo: %@", [error userInfo]);
                                     NSAssert(false, [error localizedDescription]);
                                  }
                                  [weakSelf mergeWithObject:shipment];
                                  completion(nil);
                               }];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(error);
                            }];
}

/**
 * Generate a postage label for this shipment
 */
- (void)generateLabel:(NSString *)fileFormat completion:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"shipments/%@/label", self.itemId]
                         parameters:@{@"file_format": fileFormat}
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                  if (error) {
                                     NSLog(@"Error userInfo: %@", [error userInfo]);
                                     NSAssert(false, [error localizedDescription]);
                                  }
                                  [weakSelf mergeWithObject:shipment];
                                  completion(nil);
                               }];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(error);
                            }];
}

- (void)lowestRateWithIncludeCarriers:(NSArray *)includeCarriers includeServices:(NSArray *)includeServices excludeCarriers:(NSArray *)excludeCarriers excludeServices:(NSArray *)excludeServices completion:(void(^)(EZPRate *lowestRate))completion {
   if (self.rates) {
      EZPRate *lowestRate = [self _lowestRateFromRates:self.rates includeCarriers:includeCarriers includeServices:includeServices excludeCarriers:excludeCarriers excludeServices:excludeServices];
      completion(lowestRate);
      return;
   }
   
   [self fetchRates:^(NSError *error) {
      EZPRate *lowestRate = [self _lowestRateFromRates:self.rates includeCarriers:includeCarriers includeServices:includeServices excludeCarriers:excludeCarriers excludeServices:excludeServices];
      completion(lowestRate);
   }];
}

/**
 * Get the lowest rate for the shipment. Optionally whitelist/blacklist carriers and servies from the search
 */
- (EZPRate *)_lowestRateFromRates:(NSArray *)theRates includeCarriers:(NSArray *)includeCarriers includeServices:(NSArray *)includeServices excludeCarriers:(NSArray *)excludeCarriers excludeServices:(NSArray *)excludeServices {
   NSMutableSet *ratesSet;
   if (!includeCarriers && !includeServices) {
      ratesSet = [NSMutableSet setWithArray:theRates];
   } else {
      ratesSet = [NSMutableSet set];
   }

   if (includeCarriers) {
      BOOL exists = NO;
      for (EZPRate *rate in theRates) {
         if ([includeCarriers containsObject:rate.carrier]) {
            [ratesSet addObject:rate];
            exists = YES;
         }
      }
      if (!exists) {
         return nil;
      }
   }
   
   if (includeServices) {
      BOOL exists = NO;
      for (EZPRate *rate in theRates) {
         if ([includeServices containsObject:rate.service]) {
            [ratesSet addObject:rate];
            exists = YES;
         }
      }
      if (!exists) {
         return nil;
      }
   }
   
   if (excludeCarriers) {
      for (EZPRate *rate in theRates) {
         if ([excludeCarriers containsObject:rate.carrier]) {
            [ratesSet removeObject:rate];
         }
      }
   }
   
   if (excludeServices) {
      for (EZPRate *rate in theRates) {
         if ([excludeServices containsObject:rate.service]) {
            [ratesSet removeObject:rate];
         }
      }
   }
   
   NSMutableArray *rates = [[ratesSet allObjects] mutableCopy];
   // From lower to greater
   [rates sortUsingComparator:^NSComparisonResult(EZPRate *rate1, EZPRate *rate2) {
      double obj1 = [[rate1 rate] doubleValue];
      double obj2 = [[rate2 rate] doubleValue];
      if (obj1 > obj2) {
         return NSOrderedDescending;
      }
      if (obj1 < obj2) {
         return NSOrderedAscending;
      }
      return NSOrderedSame;
   }];
   
   return [rates firstObject];
}

/**
 * Generate a stamp for this shipment
 */
- (void)generateStamp:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"shipments/%@/stamp", self.itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                  if (error) {
                                     NSLog(@"Error userInfo: %@", [error userInfo]);
                                     NSAssert(false, [error localizedDescription]);
                                  }
                                  [weakSelf mergeWithObject:shipment];
                                  completion(nil);
                               }];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(error);
                            }];
}

/**
 * Generate a stamp for this shipment
 */
- (void)generateBarcode:(void(^)(NSError *error))completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   __weak EZPShipment *weakSelf = self;
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"shipments/%@/barcode", self.itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPShipment success:responseObject completion:^(EZPShipment *shipment, NSError *error) {
                                  if (error) {
                                     NSLog(@"Error userInfo: %@", [error userInfo]);
                                     NSAssert(false, [error localizedDescription]);
                                  }
                                  [weakSelf mergeWithObject:shipment];
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
   
   [mappingProvider mapFromDictionaryKey:@"rates" toPropertyKey:@"rates"
                          withObjectType:[EZPRate class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPRate class]];
   
   [mappingProvider mapFromDictionaryKey:@"fees" toPropertyKey:@"fees"
                          withObjectType:[EZPFee class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"forms" toPropertyKey:@"forms"
                          withObjectType:[EZPForm class] forClass:[self class]];
   
   [mappingProvider mapFromDictionaryKey:@"carrier_accounts" toPropertyKey:@"carrier_accounts"
                          withObjectType:[EZPCarrierAccount class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPCarrierAccount class]];
   
   [mappingProvider mapFromDictionaryKey:@"customs_items" toPropertyKey:@"customs_items"
                          withObjectType:[EZPCustomsItem class] forClass:[EZPCustomsInfo class]];
   
   return mappingProvider;
}

@end
