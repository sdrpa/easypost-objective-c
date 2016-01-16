
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPObject (Synchronous)

+ (id)resultObjectWithResponse:(id)responseObject;

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters;
+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters rootObject:(NSString *)rootObject;
+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters;
+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters rootObject:(NSString *)rootObject;
+ (id)PUT:(NSString *)path parameters:(NSDictionary *)parameters;

@end
