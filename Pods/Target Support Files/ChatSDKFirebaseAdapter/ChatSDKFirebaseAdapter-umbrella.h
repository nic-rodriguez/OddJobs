#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Firebase+Paths.h"
#import "NSManagedObject+Status.h"
#import "ChatFirebaseAdapter.h"
#import "BEntity.h"
#import "BFirebaseNetworkAdapter.h"
#import "BStateManager.h"
#import "CCMessageWrapper.h"
#import "CCThreadWrapper.h"
#import "CCUserWrapper.h"
#import "BFirebaseAuthenticationHandler.h"
#import "BFirebaseBlockingHandler.h"
#import "BFirebaseCoreHandler.h"
#import "BFirebaseLastOnlineHandler.h"
#import "BFirebaseModerationHandler.h"
#import "BFirebasePublicThreadHandler.h"
#import "BFirebaseSearchHandler.h"
#import "BFirebaseUploadHandler.h"

FOUNDATION_EXPORT double ChatSDKFirebaseAdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char ChatSDKFirebaseAdapterVersionString[];

