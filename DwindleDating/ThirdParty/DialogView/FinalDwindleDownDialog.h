//  
//  Pokerkz
//
//  Created by Yunas Qazi.
//  Copyright (c) 2013 InfiniOne. All rights reserved.
//

#import "DialogView.h"

typedef void (^RequestCompletion)(NSInteger option);

@interface FinalDwindleDownDialog : DialogView
@property (retain, nonatomic) IBOutlet UIButton *btnPlayAgain;
@property (retain, nonatomic) IBOutlet UIButton *btnMatches;
@property (retain, nonatomic) IBOutlet UIImageView *ivMatchPhoto;
@property (retain, nonatomic) UIViewController *parentVC;
@property (copy, nonatomic) RequestCompletion successBlock;

+ (id) loadWithNib;

-(void) showWithImage:(UIImage *)image
         successBlock:(RequestCompletion) successBlock;


@end
