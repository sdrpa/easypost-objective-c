
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"
#import "EZPPropertyUtility.h"
#import "NSString+EZPString.h"
#import "NSDictionaryUtility.h"

#import "EZPTrackingDetail.h"

#import "OCMapper.h"

@interface EZPObject () {
}
@end

@implementation EZPObject

- (instancetype)init {
   self = [super init];
   if (self) {
      
   }
   return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
   if (!dictionary) {
      return nil;
   }
   
   self = [super init];
   if (self) {
      [self setKeyValuesWithDictionary:dictionary];
   }
   return self;
}

- (void)setKeyValuesWithDictionary:(NSDictionary *)dictionary {
   for (NSString *key in dictionary) {
      NSString *setter = [NSString stringWithFormat:@"set%@:", [key stringWithCapitalizedFirstLetter]];
      if ([self respondsToSelector:NSSelectorFromString(setter)]) {
         [self setValue:dictionary[key] forKey:key];
      }
   }
}

- (void)mergeWithObject:(EZPObject *)object {
   NSAssert(object, @"Merge object == nil");
   for (NSString *key in [object keys]) {
      id value = [object valueForKey:key];
      if (value) {
         [self setValue:value forKey:key];
      }
   }
}


- (NSString *)description {
   NSMutableString *mutableString = [NSMutableString string];
   for (NSString *key in [self keys]) {
      id value = [self valueForKey:key];
      if (value) {
         [mutableString appendFormat:@"%@: %@\n", key, [value description]];
      }
   }
   return [NSString stringWithFormat:@"<%@: %p> \n%@", NSStringFromClass([self class]), self, mutableString];
}

- (NSDictionary *)toDictionaryWithPrefix:(NSString *)prefix {
   InCodeMappingProvider *mappingProvider = [[self class] mappingProvider];
   
   ObjectMapper *objectMapper = [[ObjectMapper alloc] init];
   objectMapper.mappingProvider = mappingProvider;
   
   NSDictionaryUtility *utility = [[NSDictionaryUtility alloc] init];
   NSDictionary *objectDictionary = [objectMapper dictionaryFromObject:self];
   NSDictionary *dictionary = [utility flattenedDictionaryWithDictionary:objectDictionary prefix:prefix];
   return dictionary;
}

- (NSArray *)keys {
   return [EZPPropertyUtility propertiesWithClass:[self class]];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
   return YES;
}

+ (void)success:(id)responseObject completion:(void(^)(id object, NSError *error))completion {
   [EZPObject success:responseObject class:[self class] completion:completion];
}

+ (void)success:(id)responseObject class:(Class)objectClass completion:(void(^)(id object, NSError *error))completion {
   InCodeMappingProvider *mappingProvider = [objectClass mappingProvider];
   
   ObjectMapper *objectMapper = [[ObjectMapper alloc] init];
   objectMapper.mappingProvider = mappingProvider;
   //objectMapper.loggingProvider = [[CommonLoggingProvider alloc] initWithLogLevel:LogLevelInfo];
   
   id object = [objectMapper objectFromSource:responseObject toInstanceOfClass:objectClass];
   NSAssert(object, @"Object == nil");
   //NSLog(@"ResponseObject: %@", responseObject);
   //NSLog(@"Object: %@", object);
   
   completion(object, nil);
}

+ (InCodeMappingProvider *)mappingProvider {
   InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
   NSDictionary *propertyMap = [self propertyMap];
   for (NSString *key in propertyMap) {
      [mappingProvider mapFromDictionaryKey:key toPropertyKey:propertyMap[key] forClass:[self class]];
   }
   
   return mappingProvider;
}

+ (NSDictionary *)propertyMap {
   return @{@"id": @"itemId"};
}

@end
