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
    self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    NSArray *rowHeights = [self preCalculateRowHeights];
    
    // Globals for movement
    CGFloat currentPositionX = self.margin.left;
    CGFloat currentPositionY = self.margin.top;
    
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
        
        CGFloat layoutMargin = self.orientation == MKLayoutOrientationHorizontal ? self.margin.left : self.margin.top;
        
        BOOL needsLineBreak = *currentOrientationPosition + *currentLengthOfOrientation > totalAvailableLength + layoutMargin;
        
        // If the current position exeeds the maximum available space jump to the next line
        if (needsLineBreak) {
            *currentOrientationPosition = self.orientation == MKLayoutOrientationHorizontal ? self.margin.left : self.margin.top; // Carriage
            
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
    NSMutableArray *precalculatedRowHeights = [NSMutableArray array];
    
    CGFloat maximum = 0.0f;
    CGFloat alreadyUsedSpaceForRow = 0.0f;
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        
        MKFlowLayoutItem *item = self.items[i];
        
        CGFloat totalAvailableLength = self.orientation == MKLayoutOrientationHorizontal ? self.bounds.size.width : self.bounds.size.height;
        CGFloat currentLength = self.orientation == MKLayoutOrientationHorizontal ? [self horizontalLengthForItem:item] : [self verticalLengthForItem:item];
        CGFloat currentHeight = self.orientation == MKLayoutOrientationHorizontal ? [self verticalLengthForItem:item] : [self horizontalLengthForItem:item];
        
        maximum = MAX(maximum, currentHeight);
        alreadyUsedSpaceForRow += currentLength;
        
        
        BOOL newRowBegins = alreadyUsedSpaceForRow >= totalAvailableLength; // If the current item already will break the line
        BOOL nextItemStartsNewRow = NO;// If the next item will be in a new row
        if (i < self.items.count - 1) {
            MKFlowLayoutItem *nextItem = self.items[i + 1];
            CGFloat nextItemLength = self.orientation == MKLayoutOrientationHorizontal ? [self horizontalLengthForItem:nextItem] : [self verticalLengthForItem:nextItem];
            nextItemStartsNewRow = alreadyUsedSpaceForRow + nextItemLength >= totalAvailableLength;
        }
        BOOL isLastItem = i == self.items.count - 1; // If its the last item, we have to cover the maximum height
        if (newRowBegins || isLastItem || nextItemStartsNewRow) {
            [precalculatedRowHeights addObject:@(maximum)];
            maximum = 0.0f;
            alreadyUsedSpaceForRow = 0.0f;
        }
        
    }
    
    return [NSArray arrayWithArray:precalculatedRowHeights];
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
