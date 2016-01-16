
// Created by Sinisa Drpa, 2015.

#import <Foundation/Foundation.h>

extern BOOL const kProductionEnviroment;
extern NSString * const kTestSecretAPIKey;
extern NSString * const kLiveSecretAPIKey;

NSURL *APIBaseURL();
