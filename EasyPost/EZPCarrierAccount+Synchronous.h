
// Created by Sinisa Drpa, 2015.

#import "EZPCarrierAccount.h"

@interface EZPCarrierAccount (Synchronous)

+ (NSArray *)list;
+ (EZPCarrierAccount *)retrieve:(NSString *)carrierAccountId;
+ (EZPCarrierAccount *)create:(NSDictionary *)parameters;
+ (void)delete:(NSString *)carrierAccountId;
+ (EZPCarrierAccount *)update:(NSString *)itemId parameters:(NSDictionary *)parameters;

@end
