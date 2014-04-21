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
    
    
    NSArray *rowHeights = [self preCalculateRowHeights];
    
    // Globals for movement
    CGFloat currentPositionX = 0.0f;
    CGFloat currentPositionY = 0.0f;
    
    NSUInteger rowIndex = 0;
    
    for (MKFlowLayoutItem *item in self.items) {
        
        // Get item sizes
        CGFloat currentLengthHorizontal = [self horizontalLengthForItem:item];
        CGFloat currentLengthVertical = [self verticalLengthForItem:item];
        
        // Get pointer to the right values
        CGFloat *currentOrientationPosition = self.orientation == MKLayoutOrientationHorizontal ? &currentPositionX : &currentPositionY;
        CGFloat *currentOppositePosition  = self.orientation == MKLayoutOrientationHorizontal ? &currentPositionY : &currentPositionX;
        CGFloat *currentLengthOfOrientation = self.orientation == MKLayoutOrientationHorizontal ? &currentLengthHorizontal : &currentLengthVertical;
        
        CGFloat totalAvailableLength = self.orientation == MKLayoutOrientationHorizontal ? self.bounds.size.width : self.bounds.size.height;
        
        BOOL needsLineBreak = *currentOrientationPosition + *currentLengthOfOrientation > totalAvailableLength;
        
        // If the current position exeeds the maximum available space jump to the next line
        if (needsLineBreak) {
            *currentOrientationPosition = 0.0f; // Carriage
            
            NSNumber *rowHeightNumber = rowHeights[rowIndex];
            CGFloat rowHeight = rowHeightNumber.floatValue;
            
            *currentOppositePosition += rowHeight; // Return;
            rowIndex += 1;
        }
        
        // Get current rows height
        NSNumber *rowHeightNumber = rowHeights[rowIndex];
        CGFloat rowHeight = rowHeightNumber.floatValue;
        
        
        // The total available space
        CGRect outerRect = CGRectMake(currentPositionX,
                                      currentPositionY,
                                      self.orientation == MKLayoutOrientationHorizontal ? currentLengthHorizontal : rowHeight,
                                      self.orientation == MKLayoutOrientationVertical ? currentLengthVertical : rowHeight);
        
        // Make a padding rect within the item is being placed
        CGRect paddingRect = UIEdgeInsetsInsetRect(outerRect, item.padding);
        
        // The item rect needs to apply padding
        CGRect itemRect = outerRect;
        if (item.size.width != kMKLayoutItemSizeValueMatchParent) {
            itemRect.size.width = item.size.width;
        }
        if (item.size.height != kMKLayoutItemSizeValueMatchParent) {
            itemRect.size.height = item.size.height;
        }
        itemRect = UIEdgeInsetsInsetRect(itemRect, item.padding);
        
        itemRect = [self applyGravity:item.gravity withRect:itemRect withinRect:paddingRect];
        
        [item setFrame:itemRect];
        
        *currentOrientationPosition += *currentLengthOfOrientation;
        
    }
}

- (NSArray *)preCalculateRowHeights
{
    // Globals for movement
    CGFloat currentPositionX = 0.0f;
    CGFloat currentPositionY = 0.0f;
    
    CGFloat maximumOppositeLengthOfRow = 0.0f;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        
        MKFlowLayoutItem *item = self.items[i];
        
        // Get item sizes
        CGFloat currentLengthHorizontal = [self horizontalLengthForItem:item];
        CGFloat currentLengthVertical = [self verticalLengthForItem:item];
        
        // Get pointer to the right values
        CGFloat *currentOrientationPosition = self.orientation == MKLayoutOrientationHorizontal ? &currentPositionX : &currentPositionY;
        CGFloat *currentLengthOfOrientation = self.orientation == MKLayoutOrientationHorizontal ? &currentLengthHorizontal : &currentLengthVertical;
        CGFloat *currentLengthOfOppositeOrientation = self.orientation == MKLayoutOrientationHorizontal ? &currentLengthVertical : &currentLengthHorizontal;
        
        CGFloat totalAvailableLength = self.orientation == MKLayoutOrientationHorizontal ? self.bounds.size.width : self.bounds.size.height;
        
        // If the current position exeeds the maximum available space jump to the next line
        
        BOOL isLastItemInCurrentRow = *currentOrientationPosition + *currentLengthOfOrientation >= totalAvailableLength;
        if (i < self.items.count - 1) {
            MKFlowLayoutItem *nextItem = self.items[i + 1];
            isLastItemInCurrentRow |= *currentOrientationPosition + *currentLengthOfOrientation + nextItem.size.width >= totalAvailableLength;
        }
        
        if (isLastItemInCurrentRow || [self.items lastObject] == item) {
            *currentOrientationPosition = 0.0f; // Carriage
            maximumOppositeLengthOfRow = MAX(maximumOppositeLengthOfRow, *currentLengthOfOppositeOrientation);
            [array addObject:@(maximumOppositeLengthOfRow)];
            
            maximumOppositeLengthOfRow = 0.0f; // Reset length
        }
        
        maximumOppositeLengthOfRow = MAX(maximumOppositeLengthOfRow, *currentLengthOfOppositeOrientation);
        
        *currentOrientationPosition += *currentLengthOfOrientation;
        
    }
    
    return [NSArray arrayWithArray:array];
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
