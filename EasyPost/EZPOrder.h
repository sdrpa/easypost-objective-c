
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@class EZPAddress;
@class EZPCustomsInfo;
@class EZPShipment;
@class EZPRate;
@class EZPContainer;
@class EZPItem;

@interface EZPOrder : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *mode;
@property (copy) NSString *reference;
@property (assign) BOOL is_return;
@property (strong) NSDictionary *options;
@property (strong) NSArray *messages;
@property (strong) EZPAddress *from_address;
@property (strong) EZPAddress *return_address;
@property (strong) EZPAddress *to_address;
@property (strong) EZPAddress *buyer_address;
@property (strong) EZPCustomsInfo *customs_info;
@property (strong) NSArray<EZPShipment *> *shipments;
@property (strong) NSArray<EZPRate *> *rates;
@property (strong) NSArray<EZPContainer *> *containers;
@property (strong) NSArray<EZPItem *> *items;

+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;
- (void)create:(void(^)(NSError *error))completion;
- (void)buyWithRate:(EZPRate *)rate completion:(void(^)(NSError *error))completion;
- (void)buy:(NSString *)carrier service:(NSString *)service completion:(void(^)(NSError *error))completion;

@end
