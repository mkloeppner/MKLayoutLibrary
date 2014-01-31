//
//  MKLinearLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayout.h"
#import "MKLinearLayoutSeparatorDelegate.h"

@interface MKLinearLayout ()

@property (strong, nonatomic) NSMutableArray *separators;

@end

@implementation MKLinearLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        self.orientation = MKLinearLayoutOrientationHorizontal;
        self.separators = [[NSMutableArray alloc] init];
    }
    return self;
}

- (MKLinearLayoutItem *)addSubview:(UIView *)subview
{
    MKLinearLayoutItem *item = [[MKLinearLayoutItem alloc] initWithLayout:self subview:subview];
    [self addLayoutItem:item];
    return item;
}

- (MKLinearLayoutItem *)addSublayout:(MKLayout *)sublayout
{
    MKLinearLayoutItem *item = [[MKLinearLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self addLayoutItem:item];
    return item;
}

- (void)layoutBounds:(CGRect)bounds
{
    self.separators = [[NSMutableArray alloc] init];
    
    CGRect contentRect = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    float currentPos = 0.0f;
    float overallWeight = 0.0f;
    float alreadyUsedLength = 0.0f;
    float separatorThickness = [self.separatorDelegate separatorThicknessForLinearLayout:self];
    
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
    if (self.items.count > 0) {
        totalUseableContentLength -= (self.items.count - 1) * separatorThickness;
    }
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        
        MKLinearLayoutItem *item = self.items[i];
        
        float itemLength = [self itemLengthForTotalUseableContentLength:totalUseableContentLength forItem:item overallWeight:overallWeight alreadyUsedLength:alreadyUsedLength];
        
        CGRect itemOuterRect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        if (self.orientation == MKLinearLayoutOrientationHorizontal) {
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
        
        if (i != 0) {
            if ([self.separatorDelegate respondsToSelector:@selector(linearLayout:separatorRect:type:)]) {
                
                UIEdgeInsets separatorIntersectionOffsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                if ([self.separatorDelegate respondsToSelector:@selector(separatorIntersectionOffsetsForLinearLayout:)]) {
                    separatorIntersectionOffsets = [self.separatorDelegate separatorIntersectionOffsetsForLinearLayout:self];
                }
                
                CGRect separatorRect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
                if (self.orientation == MKLinearLayoutOrientationHorizontal) {
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
                
                [self.separators addObject:[NSValue valueWithCGRect:separatorRect]];
            }
        }
        
        CGRect marginRect = UIEdgeInsetsInsetRect(itemOuterRect, item.margin);
        
        CGRect itemInnerRect = marginRect;
        if (item.size.width != kMKLayoutItemSizeValueMatchParent) {
            itemInnerRect.size.width = item.size.width;
        }
        if (item.size.height != kMKLayoutItemSizeValueMatchParent) {
            itemInnerRect.size.height = item.size.height;
        }
        
        CGRect itemRect = [self applyGravity:item.gravity withRect:itemInnerRect withinRect:marginRect];
        
        if (item.subview) {
            item.subview.frame = itemRect;
        } else if (item.sublayout) {
            [item.sublayout layoutBounds:itemRect];
        }
        
        currentPos += itemLength + separatorThickness;
    }
    
    if (!self.item.layout || ![self.item.layout isKindOfClass:[MKLinearLayout class]]) {
        [self callSeparatorDelegate];
    }
}

- (void)callSeparatorDelegate
{
    if (self.separatorDelegate) {
        for (NSValue *value in self.separators) {
            [self.separatorDelegate linearLayout:self separatorRect:value.CGRectValue type:[self flipOrientation:self.orientation]];
        }
    }
    for (MKLinearLayoutItem *item in self.items) {
        if (item.sublayout && [item.sublayout isKindOfClass:[MKLinearLayout class]]) {
            MKLinearLayout *sublayout = (MKLinearLayout *)item.sublayout;
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
        case MKLinearLayoutOrientationHorizontal:
            return size.width;
            break;
        case MKLinearLayoutOrientationVertical:
            return size.height;
        default:
            break;
    }
    return 0.0f;
}

- (MKLinearLayoutOrientation)flipOrientation:(MKLinearLayoutOrientation)orientation
{
    if (MKLinearLayoutOrientationHorizontal == orientation) {
        return MKLinearLayoutOrientationVertical;
    }
    if (MKLinearLayoutOrientationVertical == orientation) {
        return MKLinearLayoutOrientationHorizontal;
    }
    [NSException raise:@"UnknownParamValueException" format:@"The specified orientation is unknown"];
    return -1;
}

- (NSInteger)numberOfSeparatorsForLayoutWithOrientation:(MKLinearLayoutOrientation)orientation
{
    NSInteger numberOfSeparators = MAX(0, [self numberOfItemsForLayoutsWithOrientation:orientation] - 1);
    
    for (MKLayoutItem *item in self.items) {
        if (item.sublayout) {
            if ([item.sublayout respondsToSelector:@selector(numberOfSeparatorsForLayoutWithOrientation:)]) {
                MKLinearLayout *linearLayout = (MKLinearLayout *)item.sublayout;
                numberOfSeparators += [linearLayout numberOfSeparatorsForLayoutWithOrientation:orientation];
            }
        }
    }
    
    return numberOfSeparators;
}

- (NSInteger)numberOfItemsForLayoutsWithOrientation:(MKLinearLayoutOrientation)orientation
{
    int numberOfItems = 0;
    
    for (MKLayoutItem *item in self.items) {
        if ([item.layout respondsToSelector:@selector(orientation)]) {
            MKLinearLayout *layout = (MKLinearLayout *)item.layout;
            if (layout.orientation == orientation) {
                if (layout.separatorDelegate) {
                    numberOfItems += 1;
                }
            }
        }
    }
    
    return numberOfItems;
}

@end