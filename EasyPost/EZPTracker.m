
// Created by Sinisa Drpa, 2015.

#import "EZPTracker.h"
#import "EZPRequest.h"

#import "EZPTrackingDetail.h"

#import "OCMapper.h"
#import "AFNetworking.h"

@implementation EZPTracker

/**
 * Get list of trackers
 */
+ (void)list:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] GET:@"trackers"
                         parameters:parameters
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPTracker success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create an trackers
 */
+ (void)create:(NSString *)carrier trackingCode:(NSString *)trackingCode completion:(EZPRequestCompletion)completion {
   NSDictionary *parameters = @{@"tracker[tracking_code]": trackingCode,
                                @"tracker[carrier]": carrier};
   [[EZPRequest sessionManager] POST:@"trackers"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPTracker success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Retrieve a Tracker from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"trackers/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPTracker success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

+ (InCodeMappingProvider *)mappingProvider {
   InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
   NSDictionary *propertyMap = [EZPObject propertyMap];
   for (NSString *key in propertyMap) {
      [mappingProvider mapFromDictionaryKey:key toPropertyKey:propertyMap[key] forClass:[self class]];
   }
   
   [mappingProvider mapFromDictionaryKey:@"tracking_details" toPropertyKey:@"tracking_details"
                          withObjectType:[EZPTrackingDetail class] forClass:[self class]];
   
   return mappingProvider;
}

@end
