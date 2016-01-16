
// Created by Sinisa Drpa, 2015.

#import "EZPCustomsItem.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPCustomsItem

/**
 * Retrieve a CustomsItem from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"customs_items/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPCustomsItem success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create a CustomsItem
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"customs_items"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPCustomsItem success:responseObject completion:completion];
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
