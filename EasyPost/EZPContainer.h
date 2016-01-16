
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPContainer : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *name;
@property (copy) NSString *type;
@property (copy) NSString *reference;
@property (assign) double length;
@property (assign) double width;
@property (assign) double height;
@property (assign) double max_weight;

+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion;
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;

@end
