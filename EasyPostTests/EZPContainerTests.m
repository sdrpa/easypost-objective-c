
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPContainer.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPContainerTests : XCTestCase

@end

@implementation EZPContainerTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateThenRetrieve {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPContainer create:[self parameters] completion:^(EZPContainer *container, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(container);
      [EZPContainer retrieve:[container itemId] completion:^(EZPContainer *container, NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil(container);
         XCTAssertTrue([container length] == 20.2);
         XCTAssertTrue([container width] == 10.9);
         XCTAssertTrue([container height] == 5);
         
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
   NSDictionary *parameters = @{@"container[name]": @"SampleContainer",
                                @"container[length]": @20.2,
                                @"container[width]": @10.9,
                                @"container[height]": @5
                                };
   return parameters;
}

@end
