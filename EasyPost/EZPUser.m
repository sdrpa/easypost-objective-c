
// Created by Sinisa Drpa, 2015.

#import "EZPUser.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@implementation EZPUser

/**
 * Retrieve a User from its id. If no id is specified, it returns the user for the api_key specified
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest liveSessionManager] GET:[NSString stringWithFormat:@"users/%@", itemId]
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                   EZPUser *object = [[EZPUser alloc] initWithDictionary:responseObject];
                                   completion(object, nil);
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   completion(nil, error);
                                }];
}

/**
 * Retrieve the users for the api_key specified
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)retrieveUsers:(EZPRequestCompletion)completion {
   [[EZPRequest liveSessionManager] GET:@"users"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                   EZPUser *object = [[EZPUser alloc] initWithDictionary:responseObject];
                                   completion(object, nil);
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   completion(nil, error);
                                }];
}

/**
 * Create a child user for the account associated with the api_key specified
 * REQUIRES kLiveSecretAPIKey
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"users"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                EZPUser *object = [[EZPUser alloc] initWithDictionary:responseObject];
                                completion(object, nil);
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Update the User associated with the api_key specified
 * REQUIRES kLiveSecretAPIKey
 */
- (void)update:(NSDictionary *)parameters completion:(void(^)(NSError *error))completion {
   NSParameterAssert(self.itemId);
   NSParameterAssert(parameters);
   __weak EZPUser *weakSelf = self;
   [[EZPRequest liveSessionManager] PUT:[NSString stringWithFormat:@"users/%@", self.itemId]
                             parameters:@{@"user": parameters}
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                   EZPUser *object = [[EZPUser alloc] initWithDictionary:responseObject];
                                   [weakSelf mergeWithObject:object];
                                   completion(nil);
                                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   completion(error);
                                }];
}

@end
