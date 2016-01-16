
// Created by Sinisa Drpa, 2015.

#import "NSDictionaryUtility.h"

@interface NSDictionaryUtility () {
   NSMutableArray *_mutableArray;
   NSString *_prefix;
   NSMutableArray *_keyPathArray;
   
   NSUInteger _lastDepth;
}
@end

@implementation NSDictionaryUtility

- (NSDictionary *)flattenedDictionaryWithDictionary:(NSDictionary *)dictionary prefix:(NSString *)prefix {
   NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
   NSArray *array = [self flattenedArrayWithDictionary:dictionary prefix:prefix];
   for (NSString *string in array) {
      NSArray *chunks = [string componentsSeparatedByString:@"="];
      [mutableDictionary setObject:chunks[1] forKey:chunks[0]];
   }
   return [mutableDictionary copy];
}

- (NSArray *)flattenedArrayWithDictionary:(NSDictionary *)dictionary prefix:(NSString *)prefix {
   _mutableArray = [NSMutableArray array];
   _prefix = prefix;
   _keyPathArray = [NSMutableArray array];
   
   [self flattenWithRecursion:dictionary];
   
   return [_mutableArray copy];
}

- (void)flattenWithRecursion:(id)object {
   [self enumerate:object depth:0 parent:nil];
}

- (void)enumerate:(id)object depth:(NSUInteger)depth parent:(id)parent {
   if ([object isKindOfClass:[NSDictionary class]]) {
      for (NSString *key in [object allKeys]) {
         //NSLog(@"KEY: %@", key);
         id value = object[key];
         if ([value isKindOfClass:[NSArray class]]) {
            if ([value count] == 0) {
               //NSLog(@"SKIPPED ARRAY: %@", key);
               continue;
            }
         }
         
         if ([value isKindOfClass:[NSDictionary class]]) {
            if ([value count] == 0) {
               //NSLog(@"SKIPPED DICTIONARY: %@", key);
               continue;
            }
         }
         
         if (depth < _lastDepth) {
            NSUInteger diff = _lastDepth - depth;
            NSAssert(diff >= 0, nil);
            for (int i=0; i<diff; i++) {
               [_keyPathArray removeLastObject];
            }
         }
         _lastDepth = depth;
         
         [_keyPathArray addObject:key];
         
         id child = [object objectForKey:key];
         [self enumerate:child depth:depth+1 parent:object];
      }
   }
   else if ([object isKindOfClass:[NSArray class]]) {
      if ([object count] != 0) {
         [_keyPathArray addObject:@""]; // Dummy will be replaced by array index
         
         for (NSUInteger i=0; i<[object count]; i++) {
            NSString *index = [NSString stringWithFormat:@"%li", i];
            [_keyPathArray replaceObjectAtIndex:[_keyPathArray count]-1 withObject:index];
            
            id child = object[i];
            [self enumerate:child depth:depth+1 parent:object];
         }
      }
   }
   //	It's a value, not collection
   else {
      //NSLog(@"DEPTH:%li. KEYPATH ARRAY: %@", depth, _keyPathArray);
      NSMutableString *path = [NSMutableString string];
      for (NSUInteger i=0; i<[_keyPathArray count]; i++) {
         [path appendFormat:@"[%@]", _keyPathArray[i]];
      }
      //NSLog(@"PATH: %@", path);
      //NSLog(@"REMOVED: %@", [_keyPathArray lastObject]);
      [_keyPathArray removeLastObject];
      
      NSString *keyPath = [NSString stringWithFormat:@"%@%@=%@", _prefix, path, object];
      [_mutableArray addObject:keyPath];
   }
}

@end
