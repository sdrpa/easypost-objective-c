
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPParcel.h"
#import "EZPShipment.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPParcelTests : XCTestCase

@end

@implementation EZPParcelTests

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
   [EZPParcel create:[self parameters] completion:^(EZPParcel *parcel, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(parcel);
      XCTAssertTrue([parcel length] == 20.2);
      XCTAssertTrue([parcel width] == 10.9);
      XCTAssertTrue([parcel height] == 5);
      XCTAssertTrue([parcel weight] == 65.9);
      
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
   [EZPParcel create:[self parameters] completion:^(EZPParcel *parcel, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      [EZPParcel retrieve:[parcel itemId] completion:^(EZPParcel *parcel, NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil(parcel);
         XCTAssertTrue([parcel length] == 20.2);
         XCTAssertTrue([parcel width] == 10.9);
         XCTAssertTrue([parcel height] == 5);
         XCTAssertTrue([parcel weight] == 65.9);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testPredefinedPackage {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   EZPParcel *parcel = [EZPParcel new];
   parcel.weight = 1.8;
   parcel.length = 2.0;
   parcel.width = 3.0;
   parcel.height = 4.0;
   parcel.predefined_package = @"SMALLFLATRATEBOX";
   
   EZPShipment *shipment = [EZPShipment new];
   shipment.parcel = parcel;
   [shipment create:^(NSError *error) {
      XCTAssertEqual(4.0, shipment.parcel.height);
      XCTAssertTrue([@"SMALLFLATRATEBOX" isEqualToString:shipment.parcel.predefined_package]);
      
      [expectation fulfill];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

#pragma mark

- (NSDictionary *)parameters {
   NSDictionary *parameters = @{@"parcel[length]": @20.2,
                                @"parcel[width]": @10.9,
                                @"parcel[height]": @5,
                                @"parcel[weight]": @65.9
                                };
   return parameters;
}

@end
