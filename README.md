# EasyPost Objective-C Client Library

EasyPost is a simple shipping API. You can sign up for an account at https://easypost.com

## Installation

Update EZPConfiguration.m:

```objectivec
NSString * const kTestSecretAPIKey = @"YOUR_TEST_API_KEY";
NSString * const kLiveSecretAPIKey = @"YOUR_LIVE_API_KEY";
```

to match your configuration.

## Usage

Lib. includes asynchronous and synchronous access to the API. eg. to create EZPAddress:

Asynchronous:
```objectivec
+ (void)create:(NSDictionary *)parameters completion:(EZPRequestCompletion)completion;
```

Synchronous:
```objectivec
+ (EZPAddress *)create:(NSDictionary *)parameters;
```

Synchronous is probably anti-pattern, but it's easier to use (to avoid long nesting of asynchronous callbacks). 
Asynchronous and synchronous version can be combined.

The project includes two sample applications:

- EasyPoster (OS X)
- EasyPosterMobile (iOS)

## Credits

https://github.com/mproberts/objc-promise
https://github.com/aryaxt/OCMapper

## API Documentation

Up-to-date documentation at: https://www.geteasypost.com/docs
