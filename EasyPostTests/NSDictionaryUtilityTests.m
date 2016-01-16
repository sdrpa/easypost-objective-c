
// Created by Sinisa Drpa, 2015.

#import <XCTest/XCTest.h>
#import "NSDictionaryUtility.h"

@interface NSDictionaryUtilityTests : XCTestCase

@end

@implementation NSDictionaryUtilityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFlattenedDictionaryWithDictionary {
   NSBundle *bundle = [NSBundle bundleForClass:[self class]];
   NSString *path = [bundle pathForResource:@"shipment_dictionary" ofType:@"data"];
   NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
   //NSLog(@"dictionary: %@", dictionary);
   
   NSDictionaryUtility *utility = [NSDictionaryUtility new];
   NSDictionary *result = [utility flattenedDictionaryWithDictionary:dictionary prefix:@"shipment"];
   NSLog(@"result: %@", result);
   
   XCTAssertNotNil(result);
}

@end
