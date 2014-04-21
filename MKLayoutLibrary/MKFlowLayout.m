//
//  MKFlowLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKFlowLayout.h"
#import "MKLayout_SubclassAccessors.h"

@interface MKFlowLayout ()

@property (assign, nonatomic) CGRect bounds;

@end

@implementation MKFlowLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKFlowLayoutItem);

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        _orientation = MKLayoutOrientationHorizontal;
    }
    return self;
}

- (void)layoutBounds:(CGRect)bounds
{
    self.bounds = bounds;
    
    // Globals for movement
    CGFloat currentPositionX = 0.0f;
    CGFloat currentPositionY = 0.0f;
    
    CGFloat maximumOppositeLengthOfRow = 0.0f;
    
    for (MKFlowLayoutItem *item in self.items) {
        
        // Get item sizes
        CGFloat currentLengthHorizontal = [self horizontalLengthForItem:item];
        CGFloat currentLengthVertical = [self verticalLengthForItem:item];
        
        // Get pointer to the right values
        CGFloat *currentOrientationPosition = self.orientation == MKLayoutOrientationHorizontal ? &currentPositionX : &currentPositionY;
        CGFloat *currentOppositePosition  = self.orientation == MKLayoutOrientationHorizontal ? &currentPositionY : &currentPositionX;
        CGFloat *currentLengthOfOrientation = self.orientation == MKLayoutOrientationHorizontal ? &currentLengthHorizontal : &currentLengthVertical;
        CGFloat *currentLengthOfOppositeOrientation = self.orientation == MKLayoutOrientationHorizontal ? &currentLengthVertical : &currentLengthHorizontal;
        
        CGFloat totalAvailableLength = self.orientation == MKLayoutOrientationHorizontal ? bounds.size.width : bounds.size.height;
        
        // If the current position exeeds the maximum available space jump to the next line
        if (*currentOrientationPosition >= totalAvailableLength) {
            *currentOrientationPosition = 0.0f; // Carriage
            *currentOppositePosition += maximumOppositeLengthOfRow; // Return
            
            maximumOppositeLengthOfRow = 0.0f; // Reset length
        }
        
        
        CGRect frame = CGRectMake(currentPositionX,
                                  currentPositionY,
                                  currentLengthHorizontal,
                                  currentLengthVertical);
        
        [item setFrame:frame];
        
        maximumOppositeLengthOfRow = MAX(maximumOppositeLengthOfRow, *currentLengthOfOppositeOrientation);
        
        *currentOrientationPosition += *currentLengthOfOrientation;
        
    }
}

- (CGFloat)horizontalLengthForItem:(MKLayoutItem *)item
{
    CGFloat width = item.size.width;
    if (width == kMKLayoutItemSizeValueMatchParent) {
        return self.bounds.size.width;
    }
    return width;
}

- (CGFloat)verticalLengthForItem:(MKLayoutItem *)item
{
    CGFloat height = item.size.height;
    if (height == kMKLayoutItemSizeValueMatchParent) {
        return self.bounds.size.height;
    }
    return height;
}

@end
