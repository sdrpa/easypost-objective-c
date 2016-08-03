
// Created by Sinisa Drpa, 2015.

#import "EZPAddress.h"
#import "EZPRequest.h"

#import "AFNetworking.h"

@interface EZPAddress ()
@end

@implementation EZPAddress

/**
 * Retrieve an address from its id
 */
+ (void)retrieve:(NSString *)itemId completion:(EZPRequestCompletion)completion {
   NSParameterAssert(itemId);
   [[EZPRequest sessionManager] GET:[NSString stringWithFormat:@"addresses/%@", itemId]
                         parameters:nil
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                               [EZPAddress success:responseObject completion:completion];
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               completion(nil, error);
                            }];
}

/**
 * Create an address
 */
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"addresses"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPAddress success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

/**
 * Create this address
 */
- (void)create:(EZPRequestCompletion)completion {
   if (self.itemId) {
      [NSException raise:NSInternalInconsistencyException format:@"Resource Already Created"];
   }
   
   NSDictionary *parameters = [self toDictionaryWithPrefix:@"address"];
   [EZPAddress create:parameters completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         NSLog(@"Error: %@", [error localizedDescription]);
         NSAssert(false, nil);
      }
      completion(address, error);
   }];
}

/**
 * Verify an address
 */
- (void)verify:(NSString *)carrier completion:(EZPRequestCompletion)completion {
   if (!self.itemId) {
      [self create:^(EZPAddress *address, NSError *error) {
         if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            NSAssert(false, nil);
         }
         [address _verify:carrier completion:completion];
      }];
   }
   else {
      [self _verify:carrier completion:completion];
   }
}

- (void)_verify:(NSString *)carrier completion:(EZPRequestCompletion)completion {
   NSAssert(self.itemId, @"self.itemId == nil");
   [EZPAddress retrieve:self.itemId completion:completion];
}

+ (void)createAndVerify:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion {
   [[EZPRequest sessionManager] POST:@"addresses/create_and_verify"
                          parameters:parameters
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                [EZPAddress success:responseObject completion:completion];
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                completion(nil, error);
                             }];
}

// Fix an error when trying to set the value of a BOOL to nil.
-(void)setNilValueForKey:(NSString *)key{
    if([key isEqualToString:@"residential"]){
        self.residential = NO;
    } else {
        [super setNilValueForKey:key];
    }
}


@end
