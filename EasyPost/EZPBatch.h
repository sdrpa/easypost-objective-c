
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPShipment;
@class EZPScanForm;

@interface EZPBatch : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *state;
@property (assign) NSUInteger num_shipments;
@property (copy) NSString *reference;
@property (strong) NSArray<EZPShipment *> *shipments;
@property (strong) NSDictionary *status;
@property (strong) EZPScanForm *scan_form;
@property (copy) NSString *label_url;
@property (copy) NSString *mode;
@property (copy) NSString *error;
@property (copy) NSString *message;

+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;
- (void)addShipmentsWithShipments:(NSArray *)shipments completion:(void(^)(NSError *error))completion;
- (void)addShipments:(NSArray *)shipmentIds completion:(void(^)(NSError *error))completion;
- (void)removeShipmentsWithShipments:(NSArray *)shipments completion:(void(^)(NSError *error))completion;
- (void)removeShipments:(NSArray *)shipmentIds completion:(void(^)(NSError *error))completion;

#pragma mark

- (NSArray *)shipmentIdsWithShipments:(NSArray *)shipments;
- (NSDictionary *)parametersWithShipmentIds:(NSArray *)shipmentIds;

@end
