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

@property (assign, nonatomic) CGRect contentRect;

@property (assign, nonatomic) CGFloat currentPos;
@property (assign, nonatomic) CGFloat overallWeight;
@property (assign, nonatomic) CGFloat alreadyUsedLength;
@property (assign, nonatomic) CGFloat separatorThickness;
@property (assign, nonatomic) NSInteger numberOfSeparators;

@property (assign, nonatomic) CGFloat totalUseableContentLength;

@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) MKLinearLayoutItem *currentItem;

@property (assign, nonatomic) CGFloat currentItemLength;

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
    self.contentRect = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    [self resetState];
    
    [self gatherOverallWeightAndAlreadyUsedFixedItemLengths];
    
    [self calculateTotalUseableContentLength];
    
    [self iterateAndPlaceItems];
}

- (void)resetState
{
    self.currentPos = 0.0f;
    self.overallWeight = 0.0f;
    self.alreadyUsedLength = 0.0f;
    self.separators = [[NSMutableArray alloc] init];
    
    self.separatorThickness = [self.separatorDelegate separatorThicknessForLinearLayout:self];
    self.numberOfSeparators = [self numberOfSeparators];
}

/**
 *  In order to map weight to real points.
 */
- (void)gatherOverallWeightAndAlreadyUsedFixedItemLengths
{
    [self.items enumerateObjectsUsingBlock:^(MKLinearLayoutItem *item, NSUInteger idx, BOOL *stop) {
        if (item.weight != kMKLinearLayoutWeightInvalid) {
            self.overallWeight += item.weight;
        } else if ([self lengthForSize:item.size] == kMKLayoutItemSizeValueMatchParent) {
            self.alreadyUsedLength += [self lengthForSize:self.contentRect.size];
        } else {
            self.alreadyUsedLength += [self lengthForSize:item.size];
        }
    }];
}

- (void)iterateAndPlaceItems {
    
    [self.items enumerateObjectsUsingBlock:^(MKLinearLayoutItem *item, NSUInteger idx, BOOL *stop) {
        
        self.currentIndex = idx;
        self.currentItem = item;
        
        [self calculateAndSetCurrentItemsPosition];
        
    }];
    
}

- (void)calculateAndSetCurrentItemsPosition {
    
    if ([self isItemWithBorderAndNotAFirstItem]) {
        [self applySeparatorThickness];
    }
    if ([self isNotFirstItem]) {
        [self applySpacing];
    }
    
    if ([self isItemWithBorderAndNotAFirstItem] &&
        [self.separatorDelegate respondsToSelector:@selector(linearLayout:separatorRect:type:)]) {
        [self addSeparator];
    };
    
    [self placeCurrentItem];
    [self moveCorrentPointerWithItem];
    
}

- (BOOL)isItemWithBorderAndNotAFirstItem {
    return self.currentItem.insertBorder && [self isNotFirstItem];
}

- (BOOL)isNotFirstItem {
    return self.currentIndex != 0;
}

- (void)calculateTotalUseableContentLength
{
    self.totalUseableContentLength = [self lengthForSize:self.contentRect.size];
    self.totalUseableContentLength -= self.numberOfSeparators * self.separatorThickness; // Remove separator thicknesses to keep space for separators
    self.totalUseableContentLength -= self.numberOfSeparators * (2.0f * self.spacing); // For every separator remove spacing left and right from it
    self.totalUseableContentLength -= ((self.items.count - 1) - self.numberOfSeparators) * self.spacing; // For every item without separators just remove the spacing
}

- (void)applySpacing
{
    self.currentPos += self.spacing;
}

- (void)applySeparatorThickness
{
    self.currentPos += self.separatorThickness;
}

- (void)placeCurrentItem
{
    // Get the total item length and outer rect
    [self calculateCurrentItemLength];
    
    // Move it just within the margin bounds
    CGRect itemOuterRect = [self itemOuterRectForContentRect:self.contentRect currentPos:self.currentPos itemLength:self.currentItemLength];
    
    [self.currentItem applyPositionWithinLayoutFrame:itemOuterRect];
}

- (void)calculateCurrentItemLength
{
    self.currentItemLength = 0.0f;
    if (self.currentItem.weight != kMKLinearLayoutWeightInvalid) {
        self.currentItemLength = self.currentItem.weight / self.overallWeight * (self.totalUseableContentLength - self.alreadyUsedLength);
    } else if ([self lengthForSize:self.currentItem.size] == kMKLayoutItemSizeValueMatchParent) {
        self.currentItemLength = self.totalUseableContentLength;
    } else {
        self.currentItemLength = [self lengthForSize:self.currentItem.size];
    }
}

- (void)moveCorrentPointerWithItem
{
    self.currentPos += self.currentItemLength;
}

- (void)addSeparator
{
    UIEdgeInsets separatorIntersectionOffsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    if ([self.separatorDelegate respondsToSelector:@selector(separatorIntersectionOffsetsForLinearLayout:)]) {
        separatorIntersectionOffsets = [self.separatorDelegate separatorIntersectionOffsetsForLinearLayout:self];
    }
    
    CGRect separatorRect = [self separatorRectForContentRect:self.contentRect separatorThickness:self.separatorThickness separatorIntersectionOffsets:separatorIntersectionOffsets currentPos:self.currentPos];
    
    [self.separators addObject:[NSValue valueWithCGRect:[self roundedRect:separatorRect]]];
    
    [self applySpacing];
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