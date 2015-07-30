//  
//  Pokerkz
//
//  Created by Yunas Qazi.
//  Copyright (c) 2013 InfiniOne. All rights reserved.
//

#import "DialogView.h"




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// private methods to handle the background layer and the effects
@interface DialogView (Private)

/*!
 @method     addRoundedRectToPath:rect:radius
 @abstract   Draws a background layer, depending on the given parameters.
 @discussion The method is able do draw a colored rect, the useable Views lie within the authentication view, the method
 is resuable so we can create additional colored views.
 */
- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius;

/*!
 @method     afterDismissView
 @abstract   Is called after the dismissView effect.
 @discussion This method removes the view after calling dismissView.
 */
- (void)afterDismissView;

/*!
 @method     bounceAfterInitialAnimationStopped
 @abstract   This method bounce the view back to a smaller size and will cause a last effect (endBounceEffect).
 */
- (void)bounceAfterInitialAnimationStopped;

/*!
 @method     startBounceEffect
 @abstract   This method bounce the view to 1.1 of the original size and starts the effect chain. The effectchain is started by 
 the method show and lasts kDuration seconds. 
 */
- (void)startBounceEffect;

/*!
 @method     endBounceEffect
 @abstract   This method bounce the view to the original size and end the effect chain. The effectchain is ended by 
 the method
 */
- (void)endBounceEffect;

@end


@implementation DialogView

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Getter and Setter

@synthesize innerSize = mInnerSize;
@synthesize isLandScape;
@synthesize containerView;

- (CGFloat)margin {
	return kInnerMargin;
}
- (void) initializeSettings{
    // for drawrect
    mBackGroundColor[0] = 0.0;
    mBackGroundColor[1] = 0.0;
    mBackGroundColor[2] = 0.0;
    mBackGroundColor[3] = 0.63;
    
    // default size
//    mInnerSize = CGSizeMake(kDialogWidth - kInnerMargin*2, kDialogHeight - kInnerMargin*2);
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
    
    mBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    mBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mBackgroundView];
    
}
- (id)init {
	if (self = [super initWithFrame:CGRectZero]) {
		// for drawrect
		mBackGroundColor[0] = 0.0;
		mBackGroundColor[1] = 0.0;
		mBackGroundColor[2] = 0.0;
		mBackGroundColor[3] = 0.63;
        
		// default size 
		mInnerSize = CGSizeMake(kDialogWidth - kInnerMargin*2, kDialogHeight - kInnerMargin*2);
        
		self.backgroundColor = [UIColor clearColor];
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw;
		
		mBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
		mBackgroundView.backgroundColor = [UIColor whiteColor];
		[self addSubview:mBackgroundView];
		
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// the drawRect Method draws the UIView and creates the basic content design
// further design is obtained by the view method load
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetFillColor(context, mBackGroundColor);
	CGRect backgroundRect = rect; // CGRectOffset(rect, -0.5, -0.5);
	[self addRoundedRectToPath:context rect:backgroundRect radius:0];
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	CGColorSpaceRelease(space);
}


-(void) resignCurrentResponder{
    [self endEditing:YES];
//    [self endEditing:NO];
}

-(void) addTapGesture{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGesture];
}




// initialize the view (calculate the size and position) and add the subviews 
- (void)show {
    
    [self addTapGesture];
    
	CGRect btFrame = CGRectZero;
	self.alpha = 1;
	self.frame = CGRectMake(0, 0, kDialogWidth, kDialogHeight);
    
	
    //================================================================
    //==== WINDOW ====================================================
    //================================================================
    
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
	// [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	if (!window) {
		window = ([UIApplication sharedApplication].windows)[0];
	}
    
    //================================================================
    //==================== END =======================================
    //================================================================


    CGRect  frame  = ((UIView*)[[window subviews] objectAtIndex:0]).frame;
    if (isLandScape) {
        frame = CGRectZero;
        frame.size.width = [[ UIScreen mainScreen ] bounds ].size.height;
        frame.size.height = [[ UIScreen mainScreen ] bounds ].size.width;
    }

	CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2),
								 frame.origin.y + ceil(frame.size.height/2));
    
    self.frame = frame;
	self.center = center;
    containerView.center = center;
	mBackgroundView.frame = CGRectMake(kInnerMargin, kInnerMargin, mInnerSize.width, mInnerSize.height);
	// call load, to add additional design code
	[self load];
	
	btFrame.origin.x = kDialogWidth - kQuitButtonWidth - 3;
	btFrame.origin.y = 4;
	btFrame.size.width = kQuitButtonWidth;
	btFrame.size.height = kQuitButtonHeight;
	mQuitButton.frame = btFrame;
	[self addSubview:mQuitButton];
	
	// put the view in the application keyWindow, if not set then in the first window object this behaviour is not
	// depending on any controller, similar to a modal view, also save the statusbarstyle and restore after dismiss
	mOldStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[[window subviews] objectAtIndex:0] addSubview:self];

	
	[self dialogWillAppear]; // override dialogWillAppear to add additional code
	[self startBounceEffect]; // start an effect chain first resize - then bounce one time and return to original size
}

- (void)dismissView:(BOOL)animated { 
//	[[UIApplication sharedApplication] setStatusBarStyle:mOldStyle animated:YES];
	if(!animated) {
		[self removeFromSuperview];
		return;
	}
	
	// create effect and set the alpha value
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(afterDismissView)];
	self.alpha = 0;
	[UIView commitAnimations];
}

- (void)cancel {
	[self dismissView:YES];
}

- (void)load {
	// override point
}

- (void)dialogWillAppear {
	// override point
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius {
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	
	// radius 0 ignore and draw normal rect
	if (radius == 0) {
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddRect(context, rect);
	} else {    
		rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
		// translate to the offset 0, 0, if necessary
		CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
		CGContextScaleCTM(context, radius, radius); 
		float fw = CGRectGetWidth(rect) / radius;
		float fh = CGRectGetHeight(rect) / radius;
		
		// generate arcs to our rect
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // right bottom
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);   // left bottom
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);    // left top
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);  // right top
	}	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark bounce effect

- (void)bounceAfterInitialAnimationStopped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDuration/2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(endBounceEffect)];
	self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)startBounceEffect {
	self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDuration/1.5];
	[UIView setAnimationDelegate:self];
	
	[UIView setAnimationDidStopSelector:@selector(bounceAfterInitialAnimationStopped)];
	self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
	[UIView commitAnimations];
}

- (void)endBounceEffect {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDuration/2];
	self.containerView.transform = CGAffineTransformIdentity; // back to original
	[UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark dismiss effect

- (void)afterDismissView {
	[self removeFromSuperview];
}


- (NSString *) currentDateString{
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YY, hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    return dateString;

}
@end
