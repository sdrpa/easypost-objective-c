
// Created by Sinisa Drpa, 2015.

#import "EZPCarrierType.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPCarrierType

/**
 * Get list of carrier types
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)list:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] GET:@"carrier_types"
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPCarrierType success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

@end
