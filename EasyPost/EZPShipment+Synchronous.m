
// Created by Sinisa Drpa, 2015.

#import "EZPShipment+Synchronous.h"
#import "EZPObject+Synchronous.h"
#import "NSDictionaryUtility.h"
#import "EZPRate.h"
#import "EZPRequest.h"
#import "EZPShipmentList.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPShipment (Synchronous)

/**
 * Get list of shipments
 */
+ (EZPShipmentList *)list:(NSDictionary *)parameters {
   NSError *error;
   NSDictionary *response = [[EZPRequest manager] syncGET:@"shipments"
                                               parameters:parameters
                                                operation:nil
                                                    error:&error];
   if (error) {
      NSAssert(false, [error localizedDescription]);
   }
   EZPShipmentList *shipmentList = error ? nil: [EZPShipmentList resultObjectWithResponse:response];
   shipmentList.filters = [parameters mutableCopy];
   return shipmentList;
}

/**
 * Retrieve a Shipment from its id
 */
+ (EZPShipment *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"shipments/%@", itemId]
         parameters:nil];
}

/**
 * Create a Shipment
 */
+ (EZPShipment *)create:(NSDictionary *)parameters {
   return [self POST:@"shipments" parameters:parameters];
}

/**
 * Create this Shipment
 */
- (void)create {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"shipment"];
   EZPShipment *object = [EZPShipment create:parameters];
   [self mergeWithObject:object];
}


/**
 * Populate the rates property for this shipment
 */
- (void)fetchRates {
   if (!self.itemId) {
      [self create];
   }
   
   EZPShipment *object = [[self class] GET:[NSString stringWithFormat:@"shipments/%@/rates", self.itemId]
         parameters:nil];
   [self mergeWithObject:object];
}

- (void)buyWithRate:(EZPRate *)rate {
   [self buy:rate.itemId];
}

/**
 * Purchase a label for this shipment with the given rate
 */
- (void)buy:(NSString *)rateId {
   EZPShipment *object = [[self class] POST:[NSString stringWithFormat:@"shipments/%@/buy", self.itemId]
          parameters:@{@"rate": @{@"id": rateId}}];
   [self mergeWithObject:object];
}

/**
 * Insure shipment for the given amount
 */
- (void)insure:(double)amount {
   EZPShipment *object = [[self class] POST:[NSString stringWithFormat:@"shipments/%@/insure", self.itemId]
                                 parameters:@{@"amount": [NSString stringWithFormat:@"%f", amount]}];
   [self mergeWithObject:object];
}

/**
 * Send a refund request to the carrier the shipment was purchased from
 */
- (void)refund {
   EZPShipment *object = [[self class] GET:[NSString stringWithFormat:@"shipments/%@/refund", self.itemId]
                                parameters:nil];
   [self mergeWithObject:object];
}

/**
 * Generate a postage label for this shipment
 */
- (void)generateLabel:(NSString *)fileFormat {
   EZPShipment *object = [[self class] GET:[NSString stringWithFormat:@"shipments/%@/label", self.itemId]
                                parameters:@{@"file_format": fileFormat}];
   [self mergeWithObject:object];
}

/**
 * Generate a stamp for this shipment
 */
- (void)generateStamp {
   EZPShipment *object = [[self class] GET:[NSString stringWithFormat:@"shipments/%@/stamp", self.itemId]
                                parameters:nil];
   [self mergeWithObject:object];
}

/**
 * Generate a stamp for this shipment
 */
- (void)generateBarcode {
   EZPShipment *object = [[self class] GET:[NSString stringWithFormat:@"shipments/%@/barcode", self.itemId]
                                parameters:nil];
   [self mergeWithObject:object];
}

/**
 * Get the lowest rate for the shipment. Optionally whitelist/blacklist carriers and servies from the search
 */
- (EZPRate *)lowestRateWithIncludeCarriers:(NSArray *)includeCarriers includeServices:(NSArray *)includeServices excludeCarriers:(NSArray *)excludeCarriers excludeServices:(NSArray *)excludeServices {
   if (!self.rates) {
      [self fetchRates];
   }
   
   return [self _lowestRateFromRates:self.rates includeCarriers:includeCarriers includeServices:includeServices excludeCarriers:excludeCarriers excludeServices:excludeServices];
}

- (EZPRate *)lowestRate {
   return [self lowestRateWithIncludeCarriers:nil includeServices:nil excludeCarriers:nil excludeServices:nil];
}

@end
