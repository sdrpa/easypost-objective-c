
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPCustomsInfo;
@class EZPAddress;
@class EZPParcel;
@class EZPPostageLabel;
@class EZPFee;
@class EZPScanForm;
@class EZPForm;
@class EZPRate;
@class EZPTracker;
@class EZPAddress;
@class EZPCarrierAccount;

@interface EZPShipment : EZPObject

@property (copy) NSString *itemId;
@property (copy) NSString *mode;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *tracking_code;
@property (copy) NSString *reference;
@property (copy) NSString *status;
@property (assign) BOOL is_return;
@property (strong) NSDictionary *options;
@property (strong) NSArray *messages;
@property (strong) EZPCustomsInfo *customs_info;
@property (strong) EZPAddress *from_address;
@property (strong) EZPAddress *to_address;
@property (strong) EZPParcel *parcel;
@property (strong) EZPPostageLabel *postage_label;
@property (strong) NSArray <EZPRate *> *rates;
@property (strong) NSArray <EZPFee *> *fees;
@property (strong) EZPScanForm *scan_form;
@property (strong) NSArray <EZPForm *> *forms;
@property (strong) EZPRate *selected_rate;
@property (strong) EZPTracker *tracker;
@property (strong) EZPAddress *buyer_address;
@property (strong) EZPAddress *return_address;
@property (copy) NSString *refund_status;
@property (copy) NSString *insurance;
@property (copy) NSString *batch_status;
@property (copy) NSString *batch_message;
@property (copy) NSString *usps_zone;
@property (copy) NSString *stamp_url;
@property (copy) NSString *barcode_url;
@property (strong) NSArray<EZPCarrierAccount *> *carrier_accounts;

+ (void)list:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;
- (void)create:(void(^)(NSError *error))completion;
- (void)fetchRates:(void(^)(NSError *error))completion;
- (void)buyWithRate:(EZPRate *)rate completion:(void(^)(NSError *error))completion;
- (void)buy:(NSString *)rateId completion:(void(^)(NSError *error))completion;
- (void)insure:(double)amount completion:(void(^)(NSError *error))completion;
- (void)refund:(void(^)(NSError *error))completion;
- (void)generateLabel:(NSString *)fileFormat completion:(void(^)(NSError *error))completion;
- (void)generateStamp:(void(^)(NSError *error))completion;
- (void)generateBarcode:(void(^)(NSError *error))completion;
- (void)lowestRateWithIncludeCarriers:(NSArray *)includeCarriers includeServices:(NSArray *)includeServices excludeCarriers:(NSArray *)excludeCarriers excludeServices:(NSArray *)excludeServices completion:(void(^)(EZPRate *lowestRate))completion;

#pragma mark

- (EZPRate *)_lowestRateFromRates:(NSArray *)theRates includeCarriers:(NSArray *)includeCarriers includeServices:(NSArray *)includeServices excludeCarriers:(NSArray *)excludeCarriers excludeServices:(NSArray *)excludeServices;

@end
