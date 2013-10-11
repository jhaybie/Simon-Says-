//
//  ColorPanelView.m
//  Simon Says!
//
//  Created by Jhaybie on 10/10/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "ColorPanelView.h"

@implementation ColorPanelView


-(void) animateColorPanelView:(ColorPanelView *)view
{
    UIColor *originalColor = self.backgroundColor;
    view.backgroundColor   = [UIColor whiteColor];
    [UIView animateWithDuration:0.5f
                     animations:
    ^{
        view.backgroundColor = originalColor;
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self animateColorPanelView:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Panel Touched"
                                                        object:[NSString stringWithFormat:@"%i", self.tag]];
}


@end
