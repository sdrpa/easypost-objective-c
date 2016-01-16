
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPCustomsItem : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *itemDescription;
@property (copy) NSString *hs_tariff_number;
@property (copy) NSString *origin_country;
@property (assign) NSUInteger quantity;
@property (assign) double value;
@property (assign) double weight;
@property (copy) NSString *mode;

+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;

@end
