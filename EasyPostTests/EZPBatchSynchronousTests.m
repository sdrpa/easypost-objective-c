
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPBatch+Synchronous.h"
#import "EZPBatch.h"
#import "EZPAddress.h"
#import "EZPParcel.h"
#import "EZPShipment+Synchronous.h"

@interface EZPBatchSynchronousTests : XCTestCase

@end

@implementation EZPBatchSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (void)testCreateAndRetrieve {
   EZPBatch *batch = [EZPBatch create:nil];
   XCTAssertNotNil(batch);
   
   EZPBatch *retrieved = [EZPBatch retrieve:batch.itemId];
   XCTAssertNotNil(retrieved);
   XCTAssertTrue([[retrieved itemId] isEqualToString:[batch itemId]]);
}

- (void)testAddRemoveShipments {
   EZPBatch *batch = [EZPBatch create:nil];
   XCTAssertNotNil(batch);
      
   EZPShipment *shipment = [self shipment];
   [shipment create];
   XCTAssertNotNil(shipment);
   
   EZPShipment *otherShipment = [self shipment];
   [otherShipment create];
   XCTAssertNotNil(otherShipment);
   
   EZPBatch *retrieved = [EZPBatch retrieve:[batch itemId]];
   XCTAssertNotNil(retrieved);
   
   [batch addShipments:@[shipment.itemId, otherShipment.itemId]];
   XCTAssertEqual(2, batch.num_shipments);
   NSPredicate *predicate;
   predicate = [NSPredicate predicateWithFormat:@"SELF.itemId contains[cd] %@", batch.shipments[0].itemId];
   XCTAssertEqual(1, [[batch.shipments filteredArrayUsingPredicate:predicate] count]);
   predicate = [NSPredicate predicateWithFormat:@"SELF.itemId contains[cd] %@", batch.shipments[1].itemId];
   XCTAssertEqual(1, [[batch.shipments filteredArrayUsingPredicate:predicate] count]);
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
