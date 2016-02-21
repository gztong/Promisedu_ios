//
//  OEXConfig.m
//  edXVideoLocker
//
//  Created by Akiva Leffert on 12/29/14.
//  Copyright (c) 2014-2015 edX. All rights reserved.
//

#import "OEXConfig.h"

#import "edX-Swift.h"
#import "Logger+OEXObjC.h"
#import "NSArray+OEXFunctional.h"

#import "OEXGoogleConfig.h"
#import "OEXFacebookConfig.h"
#import "OEXFabricConfig.h"
#import "OEXNewRelicConfig.h"
#import "OEXParseConfig.h"
#import "OEXSegmentConfig.h"
#import "OEXZeroRatingConfig.h"

// Please keep sorted alphabetically
static NSString* const OEXAPIHostURL = @"API_HOST_URL";
static NSString* const OEXBasicAuthCredentialsKey = @"BASIC_AUTH_CREDENTIALS";
static NSString* const OEXDiscussionsEnabledKey = @"DISCUSSIONS_ENABLED";
static NSString* const OEXEnvironmentDisplayName = @"ENVIRONMENT_DISPLAY_NAME";
static NSString* const OEXPlatformName = @"PLATFORM_NAME";
static NSString* const OEXPlatformDestinationName = @"PLATFORM_DESTINATION_NAME";
static NSString* const OEXFacebookAppID = @"FACEBOOK_APP_ID";
static NSString* const OEXFeedbackEmailAddress = @"FEEDBACK_EMAIL_ADDRESS";

// This key is temporary and will be removed once this feature is completed.
static NSString* const OEXProfilesEnabledKey = @"USER_PROFILES_ENABLED";
static NSString* const OEXCertificatesEnabledKey = @"CERTIFICATES_ENABLED";
static NSString* const OEXCourseSharingEnabledKey = @"COURSE_SHARING_ENABLED";

static NSString* const OEXOAuthClientID = @"OAUTH_CLIENT_ID";
static NSString* const OEXPushNotificationsKey = @"PUSH_NOTIFICATIONS";

// Composite configurations keys

static NSString* const OEXCourseEnrollmentPropertiesKey = @"COURSE_ENROLLMENT";
static NSString* const OEXFabricConfigKey = @"FABRIC";
static NSString* const OEXFacebookConfigKey = @"FACEBOOK";
static NSString* const OEXGoogleConfigKey = @"GOOGLE";
static NSString* const OEXParseConfigKey = @"PARSE";
static NSString* const OEXNewRelicConfigKey = @"NEW_RELIC";
static NSString* const OEXSegmentIOConfigKey = @"SEGMENT_IO";
static NSString* const OEXZeroRatingConfigKey = @"ZERO_RATING";

static NSString* const OEXLastUsedAPIHostURL = @"OEXLastUsedAPIHostURL";

// Debug
static NSString* const OEXDebugEnabledKey = @"SHOW_DEBUG";

@interface OEXConfig ()

@property (strong, nonatomic) NSDictionary* properties;

@end

static OEXConfig* sSharedConfig;

@implementation OEXConfig

+ (void)setSharedConfig:(OEXConfig*)config {
    sSharedConfig = config;
}

+ (instancetype)sharedConfig {
    return sSharedConfig;
}

- (id)initWithAppBundleData {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSAssert(dict, @"Unable to load config.");
    self = [self initWithDictionary:dict];
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        self.properties = dictionary;
    }
    return self;
}

- (id)objectForKey:(NSString*)key {
    if(getenv(key.UTF8String)) {
        NSString* value = @(getenv(key.UTF8String));
        NSError* error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if(error == nil && result) {
            return result;
        }
        else {
            OEXLogError(@"CONFIG", @"Couldn't read config key (%@) from environment. Invalid JSON: %@", key, value);
        }
    }
    return self.properties[key];
}

- (NSString*)stringForKey:(NSString*)key {
    NSString* value = [self objectForKey:key];
    NSAssert(value == nil || [value isKindOfClass:[NSString class]], @"Expecting string key");
    return value;
}

- (BOOL)boolForKey:(NSString*)key {
    return [[self objectForKey:key] boolValue];
}

@end

@implementation OEXConfig (OEXKnownConfigs)

- (NSURL*)apiHostURL {
    return [NSURL URLWithString:[self stringForKey:OEXAPIHostURL]];
}

- (NSString*)environmentName {
    // This is for debug display, so if we don't have it, it makes sense to return the empty string
    return [self stringForKey:OEXEnvironmentDisplayName] ?: @"";
}

- (NSString*)platformName {
    return [self stringForKey:OEXPlatformName] ?: @"My open edX instance";
}

- (NSString*)platformDestinationName {
    return [self stringForKey:OEXPlatformDestinationName] ?: @"example.com";
}

- (NSString*)feedbackEmailAddress {
    return [self stringForKey: OEXFeedbackEmailAddress];
}

- (NSString*)oauthClientID {
    return [self stringForKey:OEXOAuthClientID];
}

- (BOOL)pushNotificationsEnabled {
    return [self boolForKey:OEXPushNotificationsKey];
}

- (NSArray<BasicAuthCredential*>*)basicAuthCredentials {
    NSArray* credentials = OEXSafeCastAsClass([self objectForKey:OEXBasicAuthCredentialsKey], NSArray);
    NSArray<BasicAuthCredential*>* result = [credentials oex_map:^id(id object) {
        NSDictionary* dict = OEXSafeCastAsClass(object, NSDictionary);
        return [[BasicAuthCredential alloc] initWithDictionary:dict];
    }];
    return result ?: @[];
}

- (EnrollmentConfig*)courseEnrollmentConfig {
    NSDictionary* courseEnrollmentDictionary = [self objectForKey:OEXCourseEnrollmentPropertiesKey];
    EnrollmentConfig* courseEnrollmentConfig = [[EnrollmentConfig alloc] initWithDictionary:courseEnrollmentDictionary];
    return courseEnrollmentConfig;
}

- (OEXFacebookConfig*)facebookConfig {
    NSDictionary* dictionary = [self objectForKey:OEXFacebookConfigKey];
    OEXFacebookConfig* facebookConfig = [[OEXFacebookConfig alloc] initWithDictionary:dictionary];
    return facebookConfig;
}

- (OEXGoogleConfig*)googleConfig {
    NSDictionary* dictionary = [self objectForKey:OEXGoogleConfigKey];
    OEXGoogleConfig* googleConfig = [[OEXGoogleConfig alloc] initWithDictionary:dictionary];
    return googleConfig;
}

- (OEXFabricConfig*)fabricConfig {
    NSDictionary* dictionary = [self objectForKey:OEXFabricConfigKey];
    OEXFabricConfig* fabricConfig = [[OEXFabricConfig alloc] initWithDictionary:dictionary];
    return fabricConfig;
}

- (OEXParseConfig*)parseConfig {
    NSDictionary* dictionary = [self objectForKey:OEXParseConfigKey];
    OEXParseConfig* parseConfig = [[OEXParseConfig alloc] initWithDictionary:dictionary];
    return parseConfig;
}

- (OEXNewRelicConfig*)newRelicConfig {
    NSDictionary* dictionary = [self objectForKey:OEXNewRelicConfigKey];
    OEXNewRelicConfig* newRelicConfig = [[OEXNewRelicConfig alloc] initWithDictionary:dictionary];
    return newRelicConfig;
}

- (OEXSegmentConfig*)segmentConfig {
    NSDictionary* dictionary = [self objectForKey:OEXSegmentIOConfigKey];
    OEXSegmentConfig* segmentConfig = [[OEXSegmentConfig alloc] initWithDictionary:dictionary];
    return segmentConfig;
}

- (OEXZeroRatingConfig*)zeroRatingConfig {
    NSDictionary* dictionary = [self objectForKey:OEXZeroRatingConfigKey];
    OEXZeroRatingConfig* zeroRatingConfig = [[OEXZeroRatingConfig alloc] initWithDictionary:dictionary];
    return zeroRatingConfig;
}

- (BOOL)shouldEnableDiscussions {
    return [self boolForKey:OEXDiscussionsEnabledKey];
}

- (BOOL)shouldEnableProfiles {
    return [self boolForKey:OEXProfilesEnabledKey];
}

- (BOOL)shouldEnableCertificates {
    return [self boolForKey:OEXCertificatesEnabledKey];
}

- (BOOL)shouldEnableCourseSharing {
    return [self boolForKey:OEXCourseSharingEnabledKey];
}

- (void) setLastUsedAPIHostURL:(NSURL *)lastUsedAPIHostURL {
    [[NSUserDefaults standardUserDefaults] setObject:[lastUsedAPIHostURL absoluteString] forKey:OEXLastUsedAPIHostURL];
}

- (NSURL *) lastUsedAPIHostURL {
    return [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:OEXLastUsedAPIHostURL]];
}

#pragma mark - Debug

- (NSString *)debugDescription {
    return self.properties.description;
}

- (BOOL)shouldShowDebug {
#if DEBUG
    return [self boolForKey:OEXDebugEnabledKey];
#else 
    return false;
#endif
}

@end
