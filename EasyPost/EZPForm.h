
// Created by Sinisa Drpa, 2015.

#import "EZPObject.h"

@interface EZPForm : EZPObject

@property (copy) NSString *itemId;
@property (strong) NSDate *created_at;
@property (strong) NSDate *updated_at;
@property (copy) NSString *form_url;
@property (copy) NSString *form_type;
@property (copy) NSString *mode;

@end
