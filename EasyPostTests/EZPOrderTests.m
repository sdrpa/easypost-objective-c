
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPOrder.h"
#import "EZPAddress.h"
#import "EZPShipment.h"
#import "EZPParcel.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPOrderTests : XCTestCase

@end

@implementation EZPOrderTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieveOrder {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = [[self order] toDictionaryWithPrefix:@"order"];
   [EZPOrder create:parameters completion:^(EZPOrder *order, NSError *error) {
      XCTAssertNotNil(order.itemId);
      XCTAssertTrue([order.reference isEqualToString:@"OrderRef"]);
      
      [EZPOrder retrieve:order.itemId completion:^(EZPOrder *retrieved, NSError *error) {
         XCTAssertTrue([order.itemId isEqualToString:retrieved.itemId]);
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

// FAILS: Request failed: client error (422)?
// "error": {
//   "code": "SHIPMENT.RATES.UNAVAILABLE",
//   "message": "Missing required data to get rates.",
//   "errors": []
// }
- (void)xtestCreateFromInstance {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   EZPOrder *order = [EZPOrder new];
   [EZPAddress create:[[self toAddress] toDictionaryWithPrefix:@"address"] completion:^(EZPAddress *address, NSError *error) {
      order.to_address = address;
      
      [EZPAddress create:[[self fromAddress] toDictionaryWithPrefix:@"address"] completion:^(EZPAddress *address, NSError *error) {
         order.from_address = address;
         order.reference = @"OrderRef";
         
         [EZPShipment create:[[self shipment] toDictionaryWithPrefix:@"shipment"] completion:^(EZPShipment *shipment, NSError *error) {
            order.shipments = @[shipment];
            
            [order create:^(NSError *error) {
               XCTAssertNotNil(order.itemId);
               XCTAssertTrue([order.reference isEqualToString:@"OrderRef"]);
               
               [expectation fulfill];
            }];
         }];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testBuyOrder {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = [[self order] toDictionaryWithPrefix:@"order"];
   [EZPOrder create:parameters completion:^(EZPOrder *order, NSError *error) {
      [order buy:@"USPS" service:@"Priority" completion:^(NSError *error) {
         XCTAssertNotNil(order.shipments[0].postage_label);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

#pragma mark

- (EZPOrder *)order {
   EZPOrder *order = [EZPOrder new];
   order.to_address = [self toAddress];
   order.from_address = [self fromAddress];
   order.reference = @"OrderRef";
   order.shipments = @[[self shipment], [self shipment]];
   
   return order;
}

- (EZPShipment *)shipment {
   NSDictionary *parcelDictionary = @{@"length": @8,
                                      @"width": @6,
                                      @"height": @5,
                                      @"weight": @10};
   EZPParcel *parcel = [[EZPParcel alloc] initWithDictionary:parcelDictionary];
   
   EZPShipment *shipment = [EZPShipment new];
   shipment.from_address = [self fromAddress];
   shipment.to_address = [self toAddress];
   shipment.parcel = parcel;
   shipment.reference = @"ShipmentRef";
   
   return shipment;
}

- (EZPAddress *)toAddress {
   NSDictionary *toAddressDictionary = @{@"company": @"Simpler Postage Inc",
                                         @"street1": @"164 Townsend Street",
                                         @"street2": @"Unit 1",
                                         @"city": @"San Francisco",
                                         @"state": @"CA",
                                         @"country": @"US",
                                         @"zip": @"94107"};
   EZPAddress *toAddress = [[EZPAddress alloc] initWithDictionary:toAddressDictionary];
   XCTAssertNotNil(toAddress);
   return toAddress;
}

- (EZPAddress *)fromAddress {
   NSDictionary *fromAddressDictionary = @{@"name": @"Andrew Tribone",
                                           @"street1": @"480 Fell St",
                                           @"street2": @"#3",
                                           @"city": @"San Francisco",
                                           @"state": @"CA",
                                           @"country": @"US",
                                           @"zip": @"94102"};
   EZPAddress *fromAddress = [[EZPAddress alloc] initWithDictionary:fromAddressDictionary];
   XCTAssertNotNil(fromAddress);
   return fromAddress;
}

@end
