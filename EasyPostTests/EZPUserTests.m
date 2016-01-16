
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPUser.h"
#import "EZPConfiguration.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPUserTests : XCTestCase

@end

@implementation EZPUserTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

// REQUIRES kLiveSecretAPIKey
- (void)testRetrieve {
   if (!kProductionEnviroment) {
      return;
   }
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPUser retrieveUsers:^(NSArray *users, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(users);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

// REQUIRES kLiveSecretAPIKey
- (void)testCreate {
   if (!kProductionEnviroment) {
      return;
   }
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = @{@"user[name]": @"Child Name"};
   [EZPUser create:parameters completion:^(EZPUser *user, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(user);
      XCTAssertTrue([[user name] isEqualToString:@"Child Name"]);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

@end
