
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "EZPPickup.h"
#import "EZPAddress.h"
#import "EZPParcel.h"
#import "EZPShipment.h"

static CGFloat const kRequestTimeout = 10.0;

@interface EZPPickupTests : XCTestCase

@end

@implementation EZPPickupTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)xtestCreateThenRetrieve {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   EZPShipment *shipment = [self shipment];
   [shipment create:^(NSError *error) {
      if (error) {
         XCTFail(@"Error: %@", [error localizedDescription]);
      }
      EZPPickup *pickup = [self pickup];
      pickup.shipment = shipment;
      
      [pickup create:^(NSError *error) {
         if (error) {
            XCTFail(@"Error: %@", [error localizedDescription]);
         }
         XCTAssertNotNil([pickup itemId]);
         XCTAssertTrue([pickup.address.street1 isEqualToString:@"164 Townsend Street"]);
         [EZPPickup retrieve:[pickup itemId] completion:^(EZPPickup *retrieved, NSError *error) {
            if (error) {
               XCTFail(@"Error: %@", [error localizedDescription]);
            }
            XCTAssertTrue([retrieved.itemId isEqualToString:pickup.itemId]);
            
            [expectation fulfill];
         }];
      }];
   }];
   
   [self waitForExpectationsWithTimeout:kRequestTimeout handler:^(NSError *error) {
      if (error) {
         XCTFail(@"Timeout: %@", error);
      }
   }];
}

// FAILS: messages": [{
// "carrier": "USPS",
// "type": "rate_error",
// "message": "Service availability unknown. serverError = 1012   serverMessage = More than one facility found for address."
// }],
- (void)xtestBuyAndCancel {
   XCTestExpectation *expectation = [self expectationWithDescription:@""];
   NSDictionary *parameters = [[self pickup] toDictionaryWithPrefix:@"pickup"];
   [EZPPickup create:parameters completion:^(EZPPickup *pickup, NSError *error) {
      [pickup buyWithCarrier:@"FEDEX" service:@"Same Day" completion:^(NSError *error) {
         XCTAssertNotNil(pickup.confirmation);
         
         [pickup cancel:^(NSError *error) {
            XCTAssertTrue([pickup.status isEqualToString:@"canceled"]);
            [expectation fulfill];
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

- (EZPPickup *)pickup {
   EZPPickup *pickup = [EZPPickup new];
   pickup.is_account_address = NO;
   pickup.address = [self fromAddress];
   pickup.min_datetime = [NSDate date];
   pickup.max_datetime = [NSDate date];
   
   return pickup;
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
