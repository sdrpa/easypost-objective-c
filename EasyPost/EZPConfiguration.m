
// Created by Sinisa Drpa, 2015.

#import "EZPConfiguration.h"

BOOL const kProductionEnviroment   = NO;

NSString * const kTestSecretAPIKey = @"YOUR_TEST_API_KEY";
NSString * const kLiveSecretAPIKey = @"YOUR_LIVE_API_KEY";

static NSString * const kAPIBaseURL = @"https://api.easypost.com/v2/";

NSURL *APIBaseURL() {
   return [NSURL URLWithString:kAPIBaseURL];
}
