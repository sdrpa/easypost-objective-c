
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPCarrierType : EZPObject

@property (copy) NSString *type;
@property (copy) NSString *readable;
@property (copy) NSString *logo;
@property (strong) NSDictionary *fields;

+ (void)list:(EZPRequestCompletion)completion;

@end
