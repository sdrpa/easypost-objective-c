
// Created by Sinisa Drpa, 2015.

#import "EZPItem.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPItem

/**
 * Retrieve an Item from its id or reference
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"items/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPItem success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create an Item
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"items"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPItem success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Retrieve a Item from a custom reference
 */
+ (void)retrieve:(NSString *)name value:(NSString *)value completion:(EZPRequestCompletion)completion {
   NSParameterAssert(name);
   NSParameterAssert(value);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"items/retrieve_reference/?%@=%@", name, value]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPItem success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

+ (NSDictionary *)propertyMap {
   return @{@"id": @"itemId",
            @"description": @"itemDescription"
            };
}

@end
