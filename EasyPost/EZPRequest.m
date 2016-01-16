
// Created by Sinisa Drpa, 2015.

#import "EZPRequest.h"
#import "EZPConfiguration.h"

#import "AFNetworking.h"

@implementation EZPRequest

+ (AFHTTPRequestOperationManager *)manager {
   AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:APIBaseURL()];
   NSString *secretAPIKey = kProductionEnviroment ? kLiveSecretAPIKey : kTestSecretAPIKey;
   [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", secretAPIKey]
                    forHTTPHeaderField:@"Authorization"];
   manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
   return manager;
}

/**
 * Depending on kProductionEnviroment it will return appropriate session manager
 */
+ (AFHTTPSessionManager *)sessionManager {
   AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:APIBaseURL()];
   NSString *secretAPIKey = kProductionEnviroment ? kLiveSecretAPIKey : kTestSecretAPIKey;
   [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", secretAPIKey]
                    forHTTPHeaderField:@"Authorization"];
   
   //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
   return manager;
}

/**
 * Regardless of kProductionEnviroment some API requests MUST use kLiveSecretAPIKey otherwise the error is returned:
 * {"error":{"code":"MODE.UNAUTHORIZED","message":"This resource requires a production API Key to access.","errors":[]}}
 */
+ (AFHTTPSessionManager *)liveSessionManager {
   AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:APIBaseURL()];
   [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", kLiveSecretAPIKey]
                    forHTTPHeaderField:@"Authorization"];
   
   manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
   return manager;
}

@end
