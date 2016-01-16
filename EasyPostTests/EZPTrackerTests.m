
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPTracker.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPTrackerTests : XCTestCase

@end

@implementation EZPTrackerTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testList {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPTracker list:nil completion:^(NSArray *trackers, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(trackers);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testCreate {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPTracker create:@"USPS" trackingCode:@"EZ1000000001" completion:^(EZPTracker *tracker, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(tracker);
      XCTAssertTrue([[tracker tracking_code] isEqualToString:@"EZ1000000001"]);
      
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
   [EZPTracker create:@"USPS" trackingCode:@"EZ1000000001" completion:^(EZPTracker *tracker, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(tracker);
      [EZPTracker retrieve:[tracker itemId] completion:^(EZPTracker *tracker, NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil(tracker);
         XCTAssertTrue([[tracker tracking_code] isEqualToString:@"EZ1000000001"]);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

@end
