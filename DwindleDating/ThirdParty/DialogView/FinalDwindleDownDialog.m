//  
//  Pokerkz
//
//  Created by Yunas Qazi.
//  Copyright (c) 2013 InfiniOne. All rights reserved.
//

#import "FinalDwindleDownDialog.h"
//#import "DwindleDating-RoundImageView.h"
#import "DwindleDating-swift.h"

@implementation FinalDwindleDownDialog


#pragma mark - WEB STUFF

-(void) showWithImage:(UIImage *)image
         successBlock:(RequestCompletion) successBlock{
    
    [self.ivMatchPhoto setImage:image];
    [self show];
    self.successBlock = successBlock;
    
}


#pragma mark - XCODE STANDARD METHODS
+ (id) loadWithNib{

    FinalDwindleDownDialog *result = (FinalDwindleDownDialog *)[[NSBundle mainBundle] loadNibNamed:@"FinalDwindleDownDialog" owner:nil options:nil][0];
    result.ivMatchPhoto.layer.cornerRadius = (result.ivMatchPhoto.frame.size.width)/2;
    result.ivMatchPhoto.layer.borderWidth = 5.0;
    result.ivMatchPhoto.layer.borderColor = [UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0].CGColor;
    result.ivMatchPhoto.clipsToBounds = true;
    result.ivMatchPhoto.layer.masksToBounds = true;

    result.btnMatches.layer.cornerRadius = 5.0;
    result.btnPlayAgain.layer.cornerRadius = 5.0;
    result.containerView.layer.cornerRadius = 5.0;
    
    [result initializeSettings];

    return result;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction) buttonPressed:(UIButton*)sender{
    self.successBlock((int)sender.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
