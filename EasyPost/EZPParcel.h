
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPParcel : EZPObject

@property (copy) NSString *itemId;
@property (copy) NSString *mode;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (assign) double length;
@property (assign) double width;
@property (assign) double height;
@property (assign) double weight;
@property (copy) NSString *predefined_package;

+ (void)retrieve:(NSString *)parcelId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;

@end
