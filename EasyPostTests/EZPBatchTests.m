
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPBatch.h"
#import "EZPAddress.h"
#import "EZPParcel.h"
#import "EZPShipment.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPBatchTests : XCTestCase

@end

@implementation EZPBatchTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPBatch create:nil completion:^(EZPBatch *batch, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(batch);
      
      EZPBatch *retrieved = batch;
      [EZPBatch retrieve:[retrieved itemId] completion:^(EZPBatch *batch, NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil(batch);
         XCTAssertTrue([[retrieved itemId] isEqualToString:[batch itemId]]);
         
         [expectation fulfill];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

- (void)testAddRemoveShipments {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   [EZPBatch create:nil completion:^(EZPBatch *batch, NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      XCTAssertNotNil(batch);
      
      EZPShipment *shipment = [self shipment];
      [shipment create:^(NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         
         EZPShipment *otherShipment = [self shipment];
         [otherShipment create:^(NSError *error) {
            if (error) {
               XCTFail(@"Error: %@", [error localizedDescription]);
            }
            
            [EZPBatch retrieve:[batch itemId] completion:^(EZPBatch *batch, NSError *error) {
               if (error) {
                  XCTFail(@"Error: %@", [error localizedDescription]);
               }
               XCTAssertNotNil(batch);
               
               __weak EZPBatch *weakBatch = batch;
               [batch addShipments:@[shipment.itemId, otherShipment.itemId] completion:^(NSError *error) {
                  if (error) {
                     XCTFail(@"Error: %@", [error localizedDescription]);
                  }
                  XCTAssertEqual(2, weakBatch.num_shipments);
                  NSPredicate *predicate;
                  predicate = [NSPredicate predicateWithFormat:@"SELF.itemId contains[cd] %@", weakBatch.shipments[0].itemId];
                  XCTAssertEqual(1, [[weakBatch.shipments filteredArrayUsingPredicate:predicate] count]);
                  predicate = [NSPredicate predicateWithFormat:@"SELF.itemId contains[cd] %@", weakBatch.shipments[1].itemId];
                  XCTAssertEqual(1, [[weakBatch.shipments filteredArrayUsingPredicate:predicate] count]);
                  
                  [expectation fulfill];
               }];
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

#pragma mark

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
