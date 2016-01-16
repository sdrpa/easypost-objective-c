
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPRate : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *mode;
@property (copy) NSString *service;
@property (copy) NSString *rate;
@property (copy) NSString *list_rate;
@property (copy) NSString *retail_rate;
@property (copy) NSString *currency;
@property (copy) NSString *list_currency;
@property (copy) NSString *retail_currency;
@property (strong) NSNumber *est_delivery_days;
@property (strong) NSDate *delivery_date;
@property (strong) NSNumber *delivery_date_guaranteed;
@property (strong) NSNumber *delivery_days;
@property (copy) NSString *carrier;
@property (copy) NSString *shipment_id;
@property (copy) NSString *carrier_account_id;

+ (void)retrieve:(NSString *)rateId completion:(EZPRequestCompletion)completion;
//+ (void)retrieve:(EZPRequestCompletion)completion;

@end
