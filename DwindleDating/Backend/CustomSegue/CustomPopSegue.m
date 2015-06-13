//
//  CustomPopSegue.m
//  SegueTest
//
//  Created by coeus on 12/06/2015.
//  Copyright (c) 2015 coeus. All rights reserved.
//

#import "CustomPopSegue.h"

@implementation CustomPopSegue

-(void)perform{
    UIViewController *sourceViewContreoller = [self sourceViewController];
    
    [sourceViewContreoller.navigationController popToRootViewControllerAnimated:TRUE];
}


@end
