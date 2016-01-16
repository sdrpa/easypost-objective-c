
// Created by Sinisa Drpa, 2015.

#import <Foundation/Foundation.h>
#import "OCMapper.h"

typedef void (^EZPRequestCompletion)(id object, NSError *error);

@interface EZPObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionaryWithPrefix:(NSString *)prefix;
- (void)mergeWithObject:(EZPObject *)object;

+ (InCodeMappingProvider *)mappingProvider;
+ (NSDictionary *)propertyMap;

+ (void)success:(id)responseObject completion:(void(^)(id object, NSError *error))completion;
+ (void)success:(id)responseObject class:(Class)objectClass completion:(void(^)(id object, NSError *error))completion;

@end
