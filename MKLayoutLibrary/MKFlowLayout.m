//
//  MKFlowLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKFlowLayout.h"
#import "MKLayout_SubclassAccessors.h"

@implementation MKFlowLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKFlowLayoutItem);

- (void)layoutBounds:(CGRect)bounds
{
    CGFloat currentPositionX = 0.0f;
    CGFloat currentPositionY = 0.0f;
    
    CGFloat maximumOppositeLengthOfRow = 0.0f;
    
    for (MKFlowLayoutItem *item in self.items) {
        
        // If the current position exeeds the maximum available space jump to the next line
        if (currentPositionX >= bounds.size.width) {
            currentPositionX = 0.0f; // Carriage
            currentPositionY += maximumOppositeLengthOfRow; // Return
            
            maximumOppositeLengthOfRow = 0.0f; // Reset length
        }
        
        // Get the vertical and horizontal length of the current item
        CGFloat currentLengthHorizontal = bounds.size.width;
        CGFloat currentLengthVertical = bounds.size.height;
        
        
        CGRect frame = CGRectMake(currentPositionX, currentPositionY, currentLengthHorizontal, currentLengthVertical);
        
        [item setFrame:frame];
        
        maximumOppositeLengthOfRow = MAX(maximumOppositeLengthOfRow, currentLengthVertical);
        
        currentPositionX += currentLengthHorizontal;
        
    }
}

@end
