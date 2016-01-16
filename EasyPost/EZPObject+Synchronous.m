
// Created by Sinisa Drpa, 2015.

#import "EZPObject+Synchronous.h"
#import "EZPRequest.h"

#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"

@implementation EZPObject (Synchronous)

+ (id)resultObjectWithResponse:(id)responseObject {
   return [EZPObject resultObjectWithResponse:responseObject class:[self class]];
}

+ (id)resultObjectWithResponse:(id)responseObject class:(Class)objectClass {
   InCodeMappingProvider *mappingProvider = [objectClass mappingProvider];
   
   ObjectMapper *objectMapper = [[ObjectMapper alloc] init];
   objectMapper.mappingProvider = mappingProvider;
   //objectMapper.loggingProvider = [[CommonLoggingProvider alloc] initWithLogLevel:LogLevelInfo];
   
   id object = [objectMapper objectFromSource:responseObject toInstanceOfClass:objectClass];
   NSAssert(object, @"Object == nil");
   //NSLog(@"ResponseObject: %@", responseObject);
   //NSLog(@"Object: %@", object);
   
   return object;
}

#pragma mark

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters {
   return [self GET:path parameters:parameters rootObject:nil];
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters rootObject:(NSString *)rootObject {
   NSError *error;
   NSDictionary *response = [[EZPRequest manager] syncGET:path
                                               parameters:parameters
                                                operation:nil
                                                    error:&error];
   if (error) {
      NSAssert(false, [error localizedDescription]);
   }
   NSDictionary *objectDictionary = rootObject ? response[rootObject] : response;
   id object = error ? nil: [[self class] resultObjectWithResponse:objectDictionary];
   return object;
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters {
   return [self POST:path parameters:parameters rootObject:nil];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters rootObject:(NSString *)rootObject {
   NSError *error;
   NSDictionary *response = [[EZPRequest manager] syncPOST:path
                                                parameters:parameters
                                                 operation:nil
                                                     error:&error];
   if (error) {
      NSAssert(false, [error localizedDescription]);
   }
   NSDictionary *objectDictionary = rootObject ? response[rootObject] : response;
   //NSLog(@"objectDictionary: %@", objectDictionary);
   id object = error ? nil: [[self class] resultObjectWithResponse:objectDictionary];
   return object;
}

+ (id)PUT:(NSString *)path parameters:(NSDictionary *)parameters {
   NSError *error;
   NSDictionary *response = [[EZPRequest manager] syncPUT:path
                                               parameters:parameters
                                                operation:nil
                                                    error:&error];
   if (error) {
      NSAssert(false, [error localizedDescription]);
   }
   id object = error ? nil: [[self class] resultObjectWithResponse:response];
   return object;
}

@end
