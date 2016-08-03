
// Created by Sinisa Drpa, 2015.

#import "EZPParcel.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPParcel

/**
 * Retrieve a parcel from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"parcels/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPParcel success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create an parcel
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"parcels"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPParcel success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

-(void)setNilValueForKey:(NSString *)key{    
    if ([key isEqualToString:@"height"]) {
        [self setValue:[NSNumber numberWithFloat:0.0] forKey:@"height"];
    } else if ([key isEqualToString:@"width"]) {
        [self setValue:[NSNumber numberWithFloat:0.0] forKey:@"width"];
    } else if ([key isEqualToString:@"length"]) {
        [self setValue:[NSNumber numberWithFloat:0.0] forKey:@"length"];
    } else {
        [super setNilValueForKey:key];
    }
}

@end
