//
//  PFNetworkActivityIndicatorManager.h
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/PFNullability.h>

PF_ASSUME_NONNULL_BEGIN

/*!
 `PFNetworkActivityIndicatorManager` manages the state of the network activity indicator in the status bar.
 When enabled, it will start managing the network activity indicator in the status bar,
 according to the network operations that are performed by Parse SDK.

 The number of active requests is incremented or decremented like a stack or a semaphore,
 the activity indicator will animate, as long as the number is greater than zero.
 */
@interface PFNetworkActivityIndicatorManager : NSObject

/*!
 A Boolean value indicating whether the manager is enabled.
 If `YES` - the manager will start managing the status bar network activity indicator,
 according to the network operations that are performed by Parse SDK.
 The default value is `YES`.
 */
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

/*!
 A Boolean value indicating whether the network activity indicator is currently displayed in the status bar.
 */
@property (nonatomic, assign, readonly, getter = isNetworkActivityIndicatorVisible) BOOL networkActivityIndicatorVisible;

/*!
 The value that indicates current network activities count.
 */
@property (nonatomic, assign, readonly) NSUInteger networkActivityCount;

/*!
 @abstract Returns the shared network activity indicator manager object for the system.

 @returns The systemwide network activity indicator manager.
 */
+ (instancetype)sharedManager;

/*!
 @abstract Increments the number of active network requests.

 @discussion If this number was zero before incrementing,
 this will start animating network activity indicator in the status bar.
 */
- (void)incrementActivityCount;

/*!
 @abstract Decrements the number of active network requests.

 @discussion If this number becomes zero after decrementing,
 this will stop animating network activity indicator in the status bar.
 */
- (void)decrementActivityCount;

@end

PF_ASSUME_NONNULL_END
