
// Created by Sinisa Drpa, 2015.

#import "EZPShipmentList.h"
#import "EZPShipment.h"

@implementation EZPShipmentList

+ (InCodeMappingProvider *)mappingProvider {
   InCodeMappingProvider *mappingProvider = [[InCodeMappingProvider alloc] init];
   NSDictionary *propertyMap = [EZPObject propertyMap];
   for (NSString *key in propertyMap) {
      [mappingProvider mapFromDictionaryKey:key toPropertyKey:propertyMap[key] forClass:[self class]];
   }
   
   [mappingProvider mapFromDictionaryKey:@"shipments" toPropertyKey:@"shipments"
                          withObjectType:[EZPShipment class] forClass:[self class]];
   [mappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"itemId"
                                forClass:[EZPShipment class]];
   
   return mappingProvider;
}

@end
