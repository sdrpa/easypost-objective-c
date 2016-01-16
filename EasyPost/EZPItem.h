
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPItem : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *mode;
@property (copy) NSString *name;
@property (copy) NSString *itemDescription;
@property (copy) NSString *reference;
@property (copy) NSString *harmonized_code;
@property (copy) NSString *country_of_origin;
@property (copy) NSString *warehouse_location;
@property (assign) double value;
@property (assign) double length;
@property (assign) double width;
@property (assign) double height;
@property (assign) double weight;

+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;

@end
