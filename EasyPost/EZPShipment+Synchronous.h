
// Created by Sinisa Drpa, 2015.

#import "EZPShipment.h"

@class EZPShipmentList;
@class EZPRate;

@interface EZPShipment (Synchronous)

+ (EZPShipmentList *)list:(NSDictionary *)parameters;
+ (EZPShipment *)retrieve:(NSString *)itemId;
+ (EZPShipment *)create:(NSDictionary *)parameters;
- (void)create;
- (void)fetchRates;
- (void)buyWithRate:(EZPRate *)rate;
- (void)buy:(NSString *)rateId;
- (void)insure:(double)amount;
- (void)refund;
- (void)generateLabel:(NSString *)fileFormat;
- (void)generateStamp;
- (void)generateBarcode;
- (EZPRate *)lowestRate;
- (EZPRate *)lowestRateWithIncludeCarriers:(NSArray *)includeCarriers includeServices:(NSArray *)includeServices excludeCarriers:(NSArray *)excludeCarriers excludeServices:(NSArray *)excludeServices;

@end
