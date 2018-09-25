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

#import "JMAmimatedImageViewMacro.h"
#import "JMAnimatedImageView+Image.h"
#import "JMAnimatedImageView.h"
#import "JMAnimatedLog.h"
#import "JMAnimationOperation.h"
#import "JMGif.h"
#import "JMOImageViewAnimationDatasource.h"
#import "JMOImageViewAnimationDelegate.h"
#import "UIImage+JM.h"

FOUNDATION_EXPORT double JMAnimatedImageViewVersionNumber;
FOUNDATION_EXPORT const unsigned char JMAnimatedImageViewVersionString[];

