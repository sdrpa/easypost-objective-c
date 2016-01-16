
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPCustomsItem;

@interface EZPCustomsInfo : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *contents_type;
@property (copy) NSString *contents_explanation;
@property (copy) NSString *customs_certify;
@property (copy) NSString *customs_signer;
@property (copy) NSString *eel_pfc;
@property (copy) NSString *non_delivery_option;
@property (copy) NSString *restriction_type;
@property (copy) NSString *restriction_comments;
@property (strong) NSArray<EZPCustomsItem *> *customs_items;
@property (copy) NSString *mode;

+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;

@end
