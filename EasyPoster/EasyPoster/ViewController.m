
// Created by Sinisa Drpa, 2015.

#import "ViewController.h"

#import "EZPAddress.h"
#import "EZPParcel.h"

#import "Promise.h"
#import "Deferred.h"

@interface ViewController ()
@property (assign) BOOL sending;
@end

@implementation ViewController

- (void)viewDidLoad {
   [super viewDidLoad];

   }

- (void)setRepresentedObject:(id)representedObject {
   [super setRepresentedObject:representedObject];

   // Update the view, if already loaded.
}

- (IBAction)createAddress:(NSButton *)sender {
   __weak ViewController *weakSelf = self;
   self.sending = YES;
   
   [EZPAddress create:[self addressParameters] completion:^(EZPAddress *address, NSError *error) {
      weakSelf.sending = NO;
      
      if (error) {
         NSLog(@"Error: %@", [error localizedDescription]);
      }
      NSLog(@"Address: %@", address);
   }];
}

// Parallel execution, multiple requests at the same time, you'll be advised when all tasks are completed.
// If one of tasks fails it doesn't affect others, others will continue executing, but you'll be advised about the error.
- (IBAction)createAddressParcelUsingComposition:(NSButton *)sender {
   Promise *addressPromise = [self createAddress];
   Promise *parcelPromise = [self createParcel];
   
   Promise *andAll = [Promise and:@[addressPromise, parcelPromise]];
   [andAll when:^(id resolved) {
      NSLog(@"We fullfiled all the promises");
   } failed:^(NSError *error) {
      NSLog(@"Something failed");
   }];
}

// Serial execution, one after another if one of the chains fails the chain will break, the execution will stop
- (IBAction)createAddressParcelUsingChain:(NSButton *)sender {
   [Promise chain:^Promise *(id result) {
      return [self createAddress];
   }, ^Promise *(id result) {
      return [self createParcel];
   }, nil];
}

- (Promise *)createAddress {
   Deferred *deferred = [Deferred deferred];
   [EZPAddress create:[self addressParameters] completion:^(EZPAddress *address, NSError *error) {
      if (error) {
         NSLog(@"Error creating EZPAddress: %@", [error localizedDescription]);
         [deferred reject:error];
      }
      NSLog(@"EZPAddress created: %@", address);
      [deferred resolve:address];
   }];
   return [deferred promise];
}

- (Promise *)createParcel {
   Deferred *deferred = [Deferred deferred];
   [EZPParcel create:[self parcelParameters] completion:^(EZPParcel *parcel, NSError *error) {
      if (error) {
         NSLog(@"Error creating EZPParcel: %@", [error localizedDescription]);
         [deferred reject:error];
      }
      NSLog(@"EZPParcel created: %@", parcel);
      [deferred resolve:parcel];
   }];
   return [deferred promise];
}

- (NSDictionary *)addressParameters {
   NSDictionary *parameters = @{@"address[name]": @"Dr. Steve Brule",
                                @"address[street1]": @"179 N Harbor Dr",
                                @"address[city]": @"Redondo Beach",
                                @"address[state]": @"CA",
                                @"address[zip]": @"90277",
                                @"address[country]": @"US",
                                @"address[email]": @"dr_steve_brule@gmail.com"
                                };
   return parameters;
}

- (NSDictionary *)parcelParameters {
   NSDictionary *parameters = @{@"parcel[length]": @20.2,
                                @"parcel[width]": @10.9,
                                @"parcel[height]": @5,
                                @"parcel[weight]": @65.9
                                };
   return parameters;
}

@end
