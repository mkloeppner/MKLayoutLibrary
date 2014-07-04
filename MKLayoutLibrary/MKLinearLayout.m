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
@property (strong, nonatomic) MKLinearLayoutItem *currentItem;
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

#pragma mark - Highest level
- (void)layoutBounds:(CGRect)bounds
{
    self.contentRect = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    [self resetCalculationState];
    [self gatherOverallWeightAndAlreadyUsedFixedItemLengths]; // In order to map weight to real points
    [self calculateTotalUseableContentLength];
    [self iterateThroughAndPlaceItems];
}

#pragma mark - First level abstraction
- (void)resetCalculationState
{
    [self resetCurrentPointer];
    [self resetGlobalLayoutValues];
    [self resetSeparatorInformation];
}

/**
 *  In order to map weight to real points.
 */
- (void)gatherOverallWeightAndAlreadyUsedFixedItemLengths
{
    [self forEachItem:^{
        if ([self isCurrentItemAnWeightItem]) {
            [self increaseOverallWeightWithItemOnes];
        } else if ([self isCurrentItemAMatchParentItem]) {
            [self increaseAlreadyUsedLengthByParentContentSize];
        } else {
            [self increaseAlreadyUsedLengthByCurrentItemsLength];
        }
    }];
}

- (void)calculateTotalUseableContentLength
{
    self.totalUseableContentLength = [self lengthForSize:self.contentRect.size];
    [self reserveSeparatorSpaceForItems];
    [self reserveSpaceForSpacingArroundSeparators];
    [self reserveSpaceForSpacingBetweenItemsWithoutSeparator];
}

- (void)iterateThroughAndPlaceItems
{
    [self forEachItem:^{
        [self calculateAndSetCurrentItemsPosition];
    }];
}

#pragma mark - Second level abstraction
- (void)resetCurrentPointer {
    self.currentPos = 0.0f;
}

- (void)resetGlobalLayoutValues
{
    self.overallWeight = 0.0f;
    self.alreadyUsedLength = 0.0f;
}

- (void)resetSeparatorInformation
{
    self.separators = [[NSMutableArray alloc] init];
    self.separatorThickness = [self.separatorDelegate separatorThicknessForLinearLayout:self];
    self.numberOfSeparators = [self numberOfSeparators];
}

- (void)forEachItem:(void (^)(void))block
{
    __strong void (^execBlock)(void) = block;
    [self.items enumerateObjectsUsingBlock:^(MKLinearLayoutItem *item, NSUInteger idx, BOOL *stop) {
        self.currentIndex = idx;
        self.currentItem = item;
        execBlock();
    }];
}

- (BOOL)isCurrentItemAnWeightItem
{
    return self.currentItem.weight != kMKLinearLayoutWeightInvalid;
}

- (void)increaseOverallWeightWithItemOnes
{
    self.overallWeight += self.currentItem.weight;
}

- (BOOL)isCurrentItemAMatchParentItem
{
    return [self lengthForSize:self.currentItem.size] == kMKLayoutItemSizeValueMatchParent;
}

- (void)increaseAlreadyUsedLengthByParentContentSize {
    self.alreadyUsedLength += [self lengthForSize:self.contentRect.size];
}

- (void)increaseAlreadyUsedLengthByCurrentItemsLength {
    self.alreadyUsedLength += [self lengthForSize:self.currentItem.size];
}

- (void)reserveSeparatorSpaceForItems
{
    self.totalUseableContentLength -= self.numberOfSeparators * self.separatorThickness; // Remove separator thicknesses to keep space for separators
}

- (void)reserveSpaceForSpacingArroundSeparators
{
    self.totalUseableContentLength -= self.numberOfSeparators * (2.0f * self.spacing); // For every separator remove spacing left and right from it
}

- (void)reserveSpaceForSpacingBetweenItemsWithoutSeparator
{
    self.totalUseableContentLength -= ((self.items.count - 1) - self.numberOfSeparators) * self.spacing; // For every item without separators just remove the spacing
}

- (void)calculateAndSetCurrentItemsPosition
{
    if ([self isItemWithBorderAndNotAFirstItem]) {
        [self movePointerBySeparatorThickness];
    }
    if ([self isNotFirstItem]) {
        [self movePointerBySpacing];
    }
    if ([self isItemWithBorderAndNotAFirstItem] && [self doesDelegateRespondsToCreateSelector]) {
        [self addSeparator];
        [self movePointerBySpacing];
    };
    
    [self placeCurrentItem];
    [self movePointerWithItem];
    
}

#pragma mark - Third level abstraction
- (BOOL)isItemWithBorderAndNotAFirstItem
{
    return self.currentItem.insertBorder && [self isNotFirstItem];
}

- (void)movePointerBySeparatorThickness
{
    self.currentPos += self.separatorThickness;
}

- (BOOL)isNotFirstItem
{
    return self.currentIndex != 0;
}

- (void)movePointerBySpacing
{
    self.currentPos += self.spacing;
}

- (BOOL)doesDelegateRespondsToCreateSelector
{
    return [self.separatorDelegate respondsToSelector:@selector(linearLayout:separatorRect:type:)];
}

- (void)addSeparator
{
    UIEdgeInsets separatorIntersectionOffsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    if ([self.separatorDelegate respondsToSelector:@selector(separatorIntersectionOffsetsForLinearLayout:)]) {
        separatorIntersectionOffsets = [self.separatorDelegate separatorIntersectionOffsetsForLinearLayout:self];
    }
    
    CGRect separatorRect;
    if (self.orientation == MKLayoutOrientationHorizontal) {
        separatorRect = CGRectMake(self.contentRect.origin.x + self.currentPos - self.separatorThickness,
                                   self.contentRect.origin.y - separatorIntersectionOffsets.top,
                                   self.separatorThickness,
                                   self.contentRect.size.height + separatorIntersectionOffsets.top + separatorIntersectionOffsets.bottom);
    } else {
        separatorRect = CGRectMake(self.contentRect.origin.x - separatorIntersectionOffsets.left,
                                   self.contentRect.origin.y + self.currentPos - self.separatorThickness,
                                   self.contentRect.size.width + separatorIntersectionOffsets.left + separatorIntersectionOffsets.right,
                                   self.separatorThickness);
    }
    
    [self.separators addObject:[NSValue valueWithCGRect:[self roundedRect:separatorRect]]];
}

- (void)placeCurrentItem
{
    [self calculateCurrentItemLength];
    
    [self placeCurrentItemOuterBox];
}

- (void)movePointerWithItem
{
    self.currentPos += self.currentItemLength;
}

#pragma mark - Fourth level abstraction
- (void)calculateCurrentItemLength
{
    self.currentItemLength = 0.0f;
    if ([self isCurrentItemAnWeightItem]) {
        [self setCurrentItemLengthByWeight];
    } else if ([self isCurrentItemAMatchParentItem]) {
        [self setCurrentItemLengthByParentContentLength];
    } else {
        [self setCurrentItemLengthByItemsFixedSize];
    }
}

- (void)placeCurrentItemOuterBox
{
    CGRect itemOuterRect;
    if (self.orientation == MKLayoutOrientationHorizontal) {
        itemOuterRect = CGRectMake(self.contentRect.origin.x + self.currentPos,
                                   self.contentRect.origin.y,
                                   self.currentItemLength,
                                   self.contentRect.size.height);
    } else {
        itemOuterRect = CGRectMake(self.contentRect.origin.x,
                                   self.contentRect.origin.y + self.currentPos,
                                   self.contentRect.size.width,
                                   self.currentItemLength);
    }
    
    [self.currentItem applyPositionWithinLayoutFrame:itemOuterRect];
}

#pragma mark - Fith level abstraction
- (void)setCurrentItemLengthByWeight
{
    self.currentItemLength = self.currentItem.weight / self.overallWeight * (self.totalUseableContentLength - self.alreadyUsedLength);
}

- (void)setCurrentItemLengthByParentContentLength
{
    self.currentItemLength = self.totalUseableContentLength;
}

- (void)setCurrentItemLengthByItemsFixedSize
{
    self.currentItemLength = [self lengthForSize:self.currentItem.size];
}

#pragma mark - MKLayout subclass methods
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

#pragma mark - Helper
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

@end