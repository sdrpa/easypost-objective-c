
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPCustomsItem+Synchronous.h"

@interface EZPCustomsItemSynchronousTests : XCTestCase

@end

@implementation EZPCustomsItemSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   EZPCustomsItem *item = [EZPCustomsItem create:[self parameters]];
   EZPCustomsItem *retrieved = [EZPCustomsItem retrieve:item.itemId];
   XCTAssertTrue([[retrieved itemId] isEqualToString:[item itemId]]);
   XCTAssertEqual(10.0, retrieved.value);
}

- (NSDictionary *)parameters {
   NSDictionary *parameters = @{@"customs_item[description]": @"T-shirt",
                                @"customs_item[quantity]": @"1",
                                @"customs_item[weight]": @"5",
                                @"customs_item[value]": @"10",
                                @"customs_item[hs_tariff_number]": @"123456",
                                @"customs_item[origin_country]": @"US"
                                };
   return parameters;
}

@end
