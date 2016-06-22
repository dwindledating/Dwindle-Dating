//  
//  Pokerkz
//
//  Created by Yunas Qazi.
//  Copyright (c) 2013 InfiniOne. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDialogHeight    480.0  // height of the Inner view, we draw a layer arround the view
#define kDialogWidth     320.0  // width of the inner view, we draw a layer arround the view
#define kInnerMargin       5.0  // margin of the layer
#define kQuitButtonHeight 50.0  // quit button frame height, for the touchable area
#define kQuitButtonWidth  50.0  // quit button frame witdh, for the touchable area
#define kDuration            0.25 // effect duration, the bounce effect, and dismiss effect depend on this

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*!
 @class      DialogView
 @abstract   This class handles an Dialog
 @discussion This class is the base implementation to handle the Qype Dialog to add some specific beheaviour extend the 
 class. This class provides override points to add your beheaviour.
 */
@interface DialogView : UIView {
@private
	CGSize    mInnerSize;
	UIStatusBarStyle mOldStyle;
	
@protected
	UIButton *mQuitButton;
	UIView   *mBackgroundView;	
	CGFloat   mBackGroundColor[4];
}

@property (nonatomic, readonly) CGSize  innerSize; // returns the size of the usable view
@property (nonatomic, readonly) CGFloat margin;    // returns the margin of the layer
@property (nonatomic) BOOL isLandScape;    // returns the margin of the layer
@property (nonatomic, retain) IBOutlet UIView *containerView;

- (void) initializeSettings;

- (void)show;

- (void)load;

- (void)dialogWillAppear;

- (void)cancel;

- (void)dismissView:(BOOL)animated;

- (NSString *) currentDateString;

@end
