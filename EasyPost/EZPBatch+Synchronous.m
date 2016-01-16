
// Created by Sinisa Drpa, 2015.

#import "EZPBatch+Synchronous.h"
#import "EZPObject+Synchronous.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPBatch (Synchronous)

/**
 * Retrieve a Batch from its id
 */
+ (EZPBatch *)retrieve:(NSString *)itemId {
   NSParameterAssert(itemId);
   return [self GET:[NSString stringWithFormat:@"batches/%@", itemId]
                                    parameters:nil];
}

/**
 * Create a Batch
 */
+ (EZPBatch *)create:(NSDictionary *)parameters {
   return [self POST:@"batches" parameters:nil];
}

/**
 * Add shipments to the batch
 */
- (void)addShipmentsWithShipments:(NSArray *)shipments {
   [self addShipments:[self shipmentIdsWithShipments:shipments]];
}

/**
 * Add shipments to the batch
 */
- (void)addShipments:(NSArray *)shipmentIds {
   EZPBatch *batch = [[self class] POST:[NSString stringWithFormat:@"batches/%@/add_shipments", self.itemId]
           parameters:[self parametersWithShipmentIds:shipmentIds]];
   [self mergeWithObject:batch];
}

@end
