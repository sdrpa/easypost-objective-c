
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPUser+Synchronous.h"
#import "EZPConfiguration.h"

@interface EZPUserSynchronousTests : XCTestCase

@end

@implementation EZPUserSynchronousTests

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
   NSArray *users = [EZPUser retrieveUsers];
   XCTAssertNotNil(users);
}

// REQUIRES kLiveSecretAPIKey
- (void)testCreateAndUpdate {
   if (!kProductionEnviroment) {
      return;
   }
   EZPUser *user = [EZPUser create:@{@"user[name]": @"Test Name" }];
   XCTAssertNotNil(user.itemId);
   
   [user update:@{@"user[name]": @"NewTest Name" }];
    XCTAssertTrue([user.name isEqualToString:@"NewTest Name"]);
}

@end
