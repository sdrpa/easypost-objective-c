
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPTrackingDetail;

@interface EZPTracker : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *tracking_updated_at;
@property (strong) NSDate *updated_at;
@property (strong) NSDate *est_delivery_date;
@property (copy) NSString *mode;
@property (copy) NSString *shipment_id;
@property (copy) NSString *status;
@property (copy) NSString *carrier;
@property (copy) NSString *tracking_code;
@property (copy) NSString *signed_by;
@property (assign) NSNumber *weight;
@property (strong) NSArray<EZPTrackingDetail *> *tracking_details;

+ (void)list:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;
+ (void)create:(NSString *)carrier trackingCode:(NSString *)trackingCode completion:(EZPRequestCompletion)completion;
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;

@end
