
// Created by Sinisa Drpa, 2015.

#import "NSString+EZPString.h"

@implementation NSString (EZPString)

- (NSString *)stringWithCapitalizedFirstLetter {
   NSString *capitalised = self;
   if (self && self.length > 0) {
      capitalised = [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                  withString:[[self substringToIndex:1] capitalizedString]];
   }
   return capitalised;
}

@end
