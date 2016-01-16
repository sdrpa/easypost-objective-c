
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>

#import "EZPShipment+Synchronous.h"
#import "EZPShipment.h"
#import "EZPAddress+Synchronous.h"
#import "EZPParcel.h"
#import "EZPRate.h"
#import "EZPCustomsItem.h"
#import "EZPCustomsInfo.h"
#import "EZPCarrierAccount.h"
#import "EZPShipmentList+Synchronous.h"

@interface EZPShipmentSynchronousTests : XCTestCase

@end

@implementation EZPShipmentSynchronousTests

- (void)setUp {
   [super setUp];
   // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
   // Put teardown code here. This method is called after the invocation of each test method in the class.
   [super tearDown];
}

- (EZPShipment *)buyShipment {
   NSDictionary *parameters = [[self shipment] toDictionaryWithPrefix:@"shipment"];
   EZPShipment *shipment = [EZPShipment create:parameters];
   [shipment fetchRates];
   [shipment buyWithRate:[shipment.rates firstObject]];
   return shipment;
}

- (void)testCreateAndRetrieve {
   NSDictionary *parameters = [[self shipment] toDictionaryWithPrefix:@"shipment"];
   EZPShipment *shipment = [EZPShipment create:parameters];
   
   XCTAssertNotNil(shipment.itemId);
   XCTAssertTrue([[shipment reference] isEqualToString:@"ShipmentRef"]);
   
   EZPShipment *retrieved = [EZPShipment retrieve:shipment.itemId];
   XCTAssertTrue([shipment.itemId isEqualToString:retrieved.itemId]);
}

- (void)testCreateFromItself {
   EZPShipment *shipment = [self shipment];
   [shipment create];
   XCTAssertTrue([[shipment reference] isEqualToString:@"ShipmentRef"]);
}

// FAILS: Fails no error messages?
- (void)xtestRateErrorMessages {
   EZPShipment *shipment = [self shipment];
   EZPParcel *parcel = [EZPParcel new];
   parcel.predefined_package = @"FEDEXBOX";
   parcel.weight = 10.0;
   
   NSDictionary *parameters = [[self shipment] toDictionaryWithPrefix:@"shipment"];
   shipment = [EZPShipment create:parameters];
   
   XCTAssertNotNil(shipment.itemId);
   XCTAssertTrue([shipment.messages[0][@"carrier"] isEqualToString:@"USPS"]);
   XCTAssertTrue([shipment.messages[0][@"type"] isEqualToString:@"rate_error"]);
   XCTAssertTrue([shipment.messages[0][@"message"] isEqualToString:@"Unable to retrieve USPS rates for another carrier's predefined_package parcel type."]);
}

- (void)testCreateWithPreCreatedAttributes {
   EZPShipment *shipment = [self createShipmentResource];
   [shipment create];
   XCTAssertNotNil(shipment.itemId);
}

- (void)testGetRatesWithoutCreate {
   EZPShipment *shipment = [self createShipmentResource];
   [shipment fetchRates];
   XCTAssertNotNil(shipment.itemId);
   XCTAssertNotNil(shipment.rates);
}

- (void)testCreateAndBuyPlusInsurance {
   NSDictionary *parameters = [[self shipment] toDictionaryWithPrefix:@"shipment"];
   EZPShipment *shipment = [EZPShipment create:parameters];
   
   XCTAssertNotNil(shipment.rates);
   XCTAssertNotEqual(shipment.rates.count, 0);
   
   [shipment buyWithRate:shipment.rates[0]];
   XCTAssertNotNil(shipment.postage_label);
   
   [shipment insure:100.1];
   XCTAssertTrue(![shipment.insurance isEqualToString:@"100.1"]);
}

- (void)testTestRefund {
   EZPShipment *shipment = [self buyShipment];
   [shipment refund];
   XCTAssertNotNil(shipment.refund_status);
}

- (void)testLowestRate1 {
   EZPShipment *shipment = [self shipmentWithRates];
   EZPRate *lowestRate = [shipment lowestRateWithIncludeCarriers:nil includeServices:nil excludeCarriers:nil excludeServices:nil];
   XCTAssertTrue([[[self lowestUSPS] rate] isEqualToString:[lowestRate rate]]);
}

- (void)testLowestRate2 {
   EZPShipment *shipment = [self shipmentWithRates];
   EZPRate *lowestRate =  [shipment lowestRateWithIncludeCarriers:@[@"UPS"] includeServices:nil excludeCarriers:nil excludeServices:nil];
   XCTAssertTrue([[[self lowestUPS] rate] isEqualToString:[lowestRate rate]]);
}

- (void)testLowestRate3 {
   EZPShipment *shipment = [self shipmentWithRates];
   EZPRate *lowestRate = [shipment lowestRateWithIncludeCarriers:nil includeServices:@[@"Priority"] excludeCarriers:nil excludeServices:nil];
   XCTAssertTrue([[[self highestUSPS] rate] isEqualToString:[lowestRate rate]]);
}

- (void)testLowestRate4 {
   EZPShipment *shipment = [self shipmentWithRates];
   EZPRate *lowestRate =  [shipment lowestRateWithIncludeCarriers:nil includeServices:nil excludeCarriers:@[@"USPS"] excludeServices:nil];
   XCTAssertTrue([[[self lowestUPS] rate] isEqualToString:[lowestRate rate]]);
}

- (void)testLowestRate5 {
   EZPShipment *shipment = [self shipmentWithRates];
   EZPRate *lowestRate = [shipment lowestRateWithIncludeCarriers:nil includeServices:nil excludeCarriers:nil excludeServices:@[@"ParcelSelect"]];
   XCTAssertTrue([[[self highestUSPS] rate] isEqualToString:[lowestRate rate]]);
}

- (void)testLowestRate6 {
   EZPShipment *shipment = [self shipmentWithRates];
   EZPRate *lowestRate = [shipment lowestRateWithIncludeCarriers:@[@"FedEx"] includeServices:nil excludeCarriers:nil excludeServices:nil];
   XCTAssertNil(lowestRate);
}

// FAILS: The shipment.rates all have the same carrier_account_id ca_c07c4df425324d96beaa4b85c86e362e but it's not @"ca_qn6QC6fd"?
- (void)xtestCarrierAccounts {
   EZPShipment *shipment = [self createShipmentResource];
   EZPCarrierAccount *account = [EZPCarrierAccount new];
   account.itemId = @"ca_qn6QC6fd";
   shipment.carrier_accounts = @[account];
   [shipment create];
   if (shipment.rates.count > 0) {
      for (EZPRate *rate in shipment.rates) {
         XCTAssertTrue([rate.carrier_account_id isEqualToString:@"ca_qn6QC6fd"]);
      }
   }
}

- (void)testList {
   EZPShipmentList *shipmentList = [EZPShipment list:nil];
   XCTAssertNotEqual(0, shipmentList.shipments.count);
   
   EZPShipmentList *nextShipmentList = [shipmentList next];
   XCTAssertNotEqual(shipmentList.shipments[0].itemId, nextShipmentList.shipments[0].itemId);
}

#pragma mark - Helpers

- (NSDictionary *)parameters {
   return @{@"shipment[to_address][id]": @"adr_HrBKVA85",
            @"shipment[from_address][id]": @"adr_VtuTOj7o",
            @"shipment[parcel][id]": @"prcl_WDv2VzHp",
            @"shipment[customs_info][id]": @"cstinfo_bl5sE20Y",
            @"shipment[carrier_accounts][0][id]": @"ca_12345678",
            @"shipment[carrier_accounts][1][id]": @"ca_23456789"
            };
}

- (EZPShipment *)shipmentWithRates {
   EZPShipment *shipment = [self shipment];
   shipment.rates = @[[self highestUSPS], [self lowestUSPS], [self highestUPS], [self lowestUPS]];
   
   return shipment;
}

- (EZPRate *)lowestUSPS {
   return [[EZPRate alloc] initWithDictionary:@{@"rate": @"1.0", @"carrier": @"USPS", @"service": @"ParcelSelect"}];
}

- (EZPRate *)highestUSPS {
   return [[EZPRate alloc] initWithDictionary:@{@"rate": @"10.0", @"carrier": @"USPS", @"service": @"Priority"}];
}

- (EZPRate *)lowestUPS {
   return [[EZPRate alloc] initWithDictionary:@{@"rate": @"2.0", @"carrier": @"UPS", @"service": @"ParcelSelect"}];
}

- (EZPRate *)highestUPS {
   return [[EZPRate alloc] initWithDictionary:@{@"rate": @"20.0", @"carrier": @"UPS", @"service": @"Priority"}];
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

- (EZPShipment *)createShipmentResource {
   NSDictionary *toDictionary = [[self toAddress] toDictionaryWithPrefix:@"address"];
   EZPAddress *to = [EZPAddress create:toDictionary];
   NSDictionary *fromDictionary = [[self fromAddress] toDictionaryWithPrefix:@"address"];
   EZPAddress *from = [EZPAddress create:fromDictionary];

   EZPCustomsItem *item = [EZPCustomsItem new];
   item.itemDescription = @"description";
   
   EZPCustomsInfo *info = [EZPCustomsInfo new];
   info.customs_certify = @"TRUE";
   info.eel_pfc = @"NOEEI 30.37(a)";
   info.customs_items = @[item];
   
   EZPShipment *shipment = [EZPShipment new];
   shipment.from_address = from;
   shipment.to_address = to;
   NSDictionary *parcelDictionary = @{@"length": @8,
                                      @"width": @6,
                                      @"height": @5,
                                      @"weight": @10};
   EZPParcel *parcel = [[EZPParcel alloc] initWithDictionary:parcelDictionary];
   shipment.parcel = parcel;
   shipment.customs_info = info;

   return shipment;
}

@end
