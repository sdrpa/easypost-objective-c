
// Created by Sinisa Drpa, 2015.

#import "EZPCarrierAccount.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPCarrierAccount

/**
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)list:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] GET:@"carrier_accounts"
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPCarrierAccount success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Retrieve a CarrierAccount from its id
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"carrier_accounts/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPCarrierAccount success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create a CarrierAccount
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"carrier_accounts"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPCarrierAccount success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Remove this CarrierAccount from your account
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)delete:(NSString *)itemId completion:(void(^)(NSError *error))completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] DELETE:[NSString stringWithFormat:@"carrier_accounts/%@", itemId]
                            parameters:nil
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                  completion(nil);
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                  completion(error);
                               }];
}

/**
 * Update this CarrierAccount
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)update:(NSString *)itemId parameters:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] PATCH:[NSString stringWithFormat:@"carrier_accounts/%@", itemId]
                           parameters:parameters
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                 EZPCarrierAccount *object = [[EZPCarrierAccount alloc] initWithDictionary:responseObject];
                                 completion(object, nil);
                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 completion(nil, error);
                              }];
}

@end
