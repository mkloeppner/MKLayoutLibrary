//
//  MKLinearLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayout.h"
#import "MKLinearLayoutSeparatorDelegate.h"
#import "MKLayout_SubclassAccessors.h"

@interface MKLinearLayout ()

@property (strong, nonatomic) NSMutableArray *separators;

@end

@implementation MKLinearLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(MKLinearLayoutItem)

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        self.spacing = 0.0f;
        self.orientation = MKLayoutOrientationHorizontal;
        self.separators = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutBounds:(CGRect)bounds
{
    self.separators = [[NSMutableArray alloc] init];
    
    CGRect contentRect = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    float currentPos = 0.0f;
    float overallWeight = 0.0f;
    float alreadyUsedLength = 0.0f;
    float separatorThickness = [self.separatorDelegate separatorThicknessForLinearLayout:self];
    NSInteger numberOfSeparators = [self numberOfSeparators];
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        MKLinearLayoutItem *item = self.items[i];
        if (item.weight != kMKLinearLayoutWeightInvalid) {
            overallWeight += item.weight;
        } else if ([self lengthForSize:item.size] == kMKLayoutItemSizeValueMatchParent) {
            alreadyUsedLength += [self lengthForSize:contentRect.size];
        } else {
            alreadyUsedLength += [self lengthForSize:item.size];
        }
    }
    
    float totalUseableContentLength = [self lengthForSize:contentRect.size];
    totalUseableContentLength -= numberOfSeparators * separatorThickness; // Remove separator thicknesses to keep space for separators
    totalUseableContentLength -= numberOfSeparators * (2.0f * self.spacing); // For every separator remove spacing left and right from it
    totalUseableContentLength -= ((self.items.count - 1) - numberOfSeparators) * self.spacing; // For every item without separators just remove the spacing
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        
        MKLinearLayoutItem *item = self.items[i];
        
        // Determinate if a separator should be added before
        BOOL insertSeparatorBeforeCurrentItem = item.insertBorder && (i != 0);
        
        if (insertSeparatorBeforeCurrentItem) {
            currentPos += separatorThickness;
        }
        if (i != 0) {
            currentPos += self.spacing;
        }
        
        // Calculate separator rect that is before the current item
        if (insertSeparatorBeforeCurrentItem && [self.separatorDelegate respondsToSelector:@selector(linearLayout:separatorRect:type:)]) {
            
            UIEdgeInsets separatorIntersectionOffsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
            if ([self.separatorDelegate respondsToSelector:@selector(separatorIntersectionOffsetsForLinearLayout:)]) {
                separatorIntersectionOffsets = [self.separatorDelegate separatorIntersectionOffsetsForLinearLayout:self];
            }
            
            CGRect separatorRect = [self separatorRectForContentRect:contentRect separatorThickness:separatorThickness separatorIntersectionOffsets:separatorIntersectionOffsets currentPos:currentPos];
            
            [self.separators addObject:[NSValue valueWithCGRect:[self roundedRect:separatorRect]]];
            
            currentPos += self.spacing;
            
        }
        
        // Get the total item length and outer rect
        float itemLength = [self itemLengthForTotalUseableContentLength:totalUseableContentLength forItem:item overallWeight:overallWeight alreadyUsedLength:alreadyUsedLength];
        
        // Move it just within the margin bounds
        CGRect itemOuterRect = [self itemOuterRectForContentRect:contentRect currentPos:currentPos itemLength:itemLength];
        
        [item applyPositionWithinLayoutFrame:itemOuterRect];
        
        // Increase the currentPos with the item length
        currentPos += itemLength;
        
    }
}

/**
 * The total available item frame moved by the current position and the spacing if it exists
 */
- (CGRect)itemOuterRectForContentRect:(CGRect)contentRect currentPos:(CGFloat)currentPos itemLength:(CGFloat)itemLength
{
    CGRect itemOuterRect;
    if (self.orientation == MKLayoutOrientationHorizontal) {
        itemOuterRect = CGRectMake(contentRect.origin.x + currentPos,
                                   contentRect.origin.y,
                                   itemLength,
                                   contentRect.size.height);
    } else {
        itemOuterRect = CGRectMake(contentRect.origin.x,
                                   contentRect.origin.y + currentPos,
                                   contentRect.size.width,
                                   itemLength);
    }
    return itemOuterRect;
}

- (CGRect)separatorRectForContentRect:(CGRect)contentRect separatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets currentPos:(CGFloat)currentPos
{
    CGRect separatorRect;
    if (self.orientation == MKLayoutOrientationHorizontal) {
        separatorRect = CGRectMake(contentRect.origin.x + currentPos - separatorThickness,
                                   contentRect.origin.y - separatorIntersectionOffsets.top,
                                   separatorThickness,
                                   contentRect.size.height + separatorIntersectionOffsets.top + separatorIntersectionOffsets.bottom);
    } else {
        separatorRect = CGRectMake(contentRect.origin.x - separatorIntersectionOffsets.left,
                                   contentRect.origin.y + currentPos - separatorThickness,
                                   contentRect.size.width + separatorIntersectionOffsets.left + separatorIntersectionOffsets.right,
                                   separatorThickness);
    }
    return separatorRect;
}

- (void)callSeparatorDelegate
{
    if (self.separatorDelegate) {
        for (NSValue *value in self.separators) {
            [self.separatorDelegate linearLayout:self separatorRect:value.CGRectValue type:[self flipOrientation:self.orientation]];
        }
    }
    for (MKLinearLayoutItem *item in self.items) {
        if (item.sublayout && [item.sublayout respondsToSelector:@selector(callSeparatorDelegate)]) {
            id sublayout = item.sublayout;
            [sublayout callSeparatorDelegate];
        }
    }
}

/**
 * Calculates the length in pixels for an layout item
 *
 * @param item The item that is requested for its length in pixels within the current orientation of the linear layout
 * @param overallWeight The overallWeight specifies all weights of all relative sized items. It is used in order to calculate the items length relative to other relative layoutet items (weight is used instead of size)
 */
- (CGFloat)itemLengthForTotalUseableContentLength:(CGFloat)totalUseableContentLength forItem:(MKLinearLayoutItem *)item overallWeight:(CGFloat)overallWeight alreadyUsedLength:(CGFloat)alreadyUsedLength
{
    float itemLength = 0.0f;
    if (item.weight != kMKLinearLayoutWeightInvalid) {
        itemLength = item.weight / overallWeight * (totalUseableContentLength - alreadyUsedLength);
    } else if ([self lengthForSize:item.size] == kMKLayoutItemSizeValueMatchParent) {
        itemLength = totalUseableContentLength;
    } else if ([self lengthForSize:item.size] == kMKLayoutItemSizeValueWrapContent) {
        CGSize contentSize = [item.subview sizeThatFits:[self sizeWithLength:(totalUseableContentLength - alreadyUsedLength) andHeight:[self heightForSize:self.bounds.size]]];
        itemLength = [self lengthForSize:contentSize];
    } else {
        itemLength = [self lengthForSize:item.size];
    }
    return itemLength;
}

/**
 * Returns a float that represents the length of the item within an orientation
 */
- (CGFloat)lengthForSize:(CGSize)size
{
    switch (self.orientation) {
        case MKLayoutOrientationHorizontal:
            return size.width;
            break;
        case MKLayoutOrientationVertical:
            return size.height;
        default:
            break;
    }
    return 0.0f;
}

/**
 * Returns a float that represents the height of the item accordingly the orientation
 */
- (CGFloat)heightForSize:(CGSize)size
{
    switch (self.orientation) {
        case MKLayoutOrientationHorizontal:
            return size.height;
            break;
        case MKLayoutOrientationVertical:
            return size.width;
        default:
            break;
    }
    return 0.0f;
}

/**
 *  Converts layout direction values (length, height) into the approbiate width and size values of the linear layout
 *
 *  @param length The value in layout direction
 *  @param height The opposite value
 *
 *  @return A CGSize representing a length, an height accordingly to the direction
 */
- (CGSize)sizeWithLength:(CGFloat)length andHeight:(CGFloat)height
{
    if (self.orientation == MKLayoutOrientationHorizontal) {
        return CGSizeMake(length, height);
    } else if (self.orientation == MKLayoutOrientationVertical) {
        return CGSizeMake(height, length);
    }
    [NSException raise:@"InvalidArgumentException" format:@"The layout direction %i is invalid", self.orientation];
    return CGSizeZero;
}

- (NSInteger)numberOfBordersForOrientation:(MKLayoutOrientation)orientation
{
    NSInteger numberOfSeparators = 0;
    
    MKLayoutOrientation separatorOrientation = [self flipOrientation:self.orientation];
    
    if (separatorOrientation == orientation) {
        numberOfSeparators = MAX(0, [self numberOfSeparators]);
    }
    
    for (int i = 0; i < self.items.count; i++) {
        MKLayoutItem *item = self.items[i];
        if (item.sublayout) {
            MKLinearLayout *linearLayout = (MKLinearLayout *)item.sublayout;
            numberOfSeparators += [linearLayout numberOfBordersForOrientation:orientation];
        }
    }
    
    return numberOfSeparators;
}

- (NSInteger)numberOfSeparators
{
    int numberOfSeparators = 0;
    
    for (int i = 0; i < self.items.count; i++) {
        MKLayoutItem *item = self.items[i];
        
        if (i == 0) {
            continue;
        }
        
        if (item.insertBorder) {
            numberOfSeparators += 1;
        }
    }
    
    return numberOfSeparators;
}

@end