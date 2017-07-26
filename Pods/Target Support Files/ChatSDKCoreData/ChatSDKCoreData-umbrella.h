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

#import "BCoreDataManager.h"
#import "BEntityTypes.h"
#import "ChatCoreData.h"
#import "CDGroup+CoreDataProperties.h"
#import "CDGroup.h"
#import "CDMessage+CoreDataProperties.h"
#import "CDMessage.h"
#import "CDThread+CoreDataProperties.h"
#import "CDThread.h"
#import "CDUser+CoreDataProperties.h"
#import "CDUser.h"
#import "CDUserAccount+CoreDataProperties.h"
#import "CDUserAccount.h"
#import "CDUserConnection+CoreDataProperties.h"
#import "CDUserConnection.h"
#import "PHasMeta.h"

FOUNDATION_EXPORT double ChatSDKCoreDataVersionNumber;
FOUNDATION_EXPORT const unsigned char ChatSDKCoreDataVersionString[];

