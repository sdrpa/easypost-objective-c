
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPCustomsItem.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPCustomsItemTests : XCTestCase

@end

@implementation EZPCustomsItemTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreate {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPCustomsItem create:[self parameters] completion:^(EZPCustomsItem *item, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(item);
      XCTAssertTrue([[item itemDescription] isEqualToString:@"T-shirt"]);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testCreateThenRetrieve {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPCustomsItem create:[self parameters] completion:^(EZPCustomsItem *item, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      NSString *createdId = [item itemId];
      [EZPCustomsItem retrieve:createdId completion:^(EZPCustomsItem *item, NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil(item);
         XCTAssertTrue([[item itemId] isEqualToString:createdId]);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
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
