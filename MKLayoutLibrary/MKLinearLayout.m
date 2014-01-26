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

// Transient, outdated after layout
@property (assign, nonatomic) CGRect bounds;

@end

@implementation MKLinearLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        self.orientation = MKLinearLayoutOrientationHorizontal;
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
    self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);

    float currentPos = 0.0f;
    float overallWeight = 0.0f;
    float overallLength = 0.0f;

    [self calculateOverallWeight:&overallWeight overallLength:&overallLength];

    float contentLength = [self lengthForOrientation:self.orientation];

    for (NSUInteger i = 0; i < self.items.count; i++) {

        MKLinearLayoutItem *item = self.items[i];

        CGRect rect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);

        CGFloat separatorThickness = [self.separatorDelegate separatorThicknessForLinearLayout:self];

        // Apply current position
        if (self.orientation == MKLinearLayoutOrientationHorizontal) {
            rect.origin.x = currentPos;
        } else if (self.orientation == MKLinearLayoutOrientationVertical) {
            rect.origin.y = currentPos;
        } else {
            [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", self.orientation];
        }

        // Calculate absolute size
        rect.size.width = [self lengthForItem:item orientation:MKLinearLayoutOrientationHorizontal overallWeight:overallWeight overallLength:overallLength contentLength:contentLength];
        rect.size.height = [self lengthForItem:item orientation:MKLinearLayoutOrientationVertical overallWeight:overallWeight overallLength:overallLength contentLength:contentLength];

        // Apply offset for recursive layout calls in order to achieve sublayouts
        rect.origin.x += self.bounds.origin.x;
        rect.origin.y += self.bounds.origin.y;

        // Move the cursor in order to reserve the whole rectangle for the current item view.
        currentPos += [self lengthFromRect:rect orientation:self.orientation];

        // Get the total reserved item frame in order to apply inner gravity without nesting subviews 
        CGRect outerRect = [self reservedTotalSpaceForRect:rect];

        // Reduce sizes in order to achieve the padding for the borders
        rect = [self applyPadding:separatorThickness forRect:rect firstItem:(i == 0)];
        outerRect = [self applyPadding:separatorThickness forRect:outerRect firstItem:(i == 0)];

        // Apply the margin in order to achieve spacings around the item view
        rect = UIEdgeInsetsInsetRect(rect, item.margin);
        outerRect = UIEdgeInsetsInsetRect(outerRect, item.margin);

        // Apply gravity
        rect = [self applyGravity:item.gravity withRect:rect withinRect:outerRect];

        // Notify separator information
        if (i != 0 && i != self.items.count) {
            if ([self.separatorDelegate respondsToSelector:@selector(linearLayout:separatorRect:type:)]) {

                CGRect separatorRect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
                MKLinearLayoutOrientation separatorOrientation = MKLinearLayoutOrientationVertical;

                if (self.orientation == MKLinearLayoutOrientationHorizontal) {
                    separatorRect = CGRectMake(outerRect.size.width,
                                               outerRect.origin.y,
                                               separatorThickness,
                                               outerRect.size.height);
                    separatorOrientation = MKLinearLayoutOrientationHorizontal;
                } else if (self.orientation == MKLinearLayoutOrientationVertical) {

                    separatorRect = CGRectMake(outerRect.origin.x,
                                               outerRect.size.height,
                                               outerRect.size.width,
                                               separatorThickness);
                    separatorOrientation = MKLinearLayoutOrientationHorizontal;

                } else {
                    [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", self.orientation];
                }

                [self.separatorDelegate linearLayout:self separatorRect:separatorRect type:separatorOrientation];
            }
        }
        if (item.subview) {
            item.subview.frame = rect;
        } else if (item.sublayout) {
            [item.sublayout layoutBounds:rect];
        }

    }

    self.bounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGRect)applyPadding:(CGFloat)padding forRect:(CGRect)rect firstItem:(BOOL)firstItem
{
    CGFloat separatorThickness = [self.separatorDelegate separatorThicknessForLinearLayout:self];

    if (self.orientation == MKLinearLayoutOrientationHorizontal) {
        if (!firstItem) {
            rect.origin.x = rect.origin.x + separatorThickness / 2.0f;
        }
        rect.size.width = rect.size.width - separatorThickness / 2.0f;
    } else if (self.orientation == MKLinearLayoutOrientationVertical) {
        if (!firstItem) {
            rect.origin.y = rect.origin.y + separatorThickness / 2.0f;
        }
        rect.size.height = rect.size.height - separatorThickness / 2.0f;
    } else {
        [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", self.orientation];
    }
    return rect;
}

- (CGRect)reservedTotalSpaceForRect:(CGRect)rect
{
    MKLinearLayoutOrientation orientation = MKLinearLayoutOrientationVertical;

    if (self.orientation == MKLinearLayoutOrientationHorizontal) {
        orientation = MKLinearLayoutOrientationVertical;
    } else if (self.orientation == MKLinearLayoutOrientationVertical) {
        orientation = MKLinearLayoutOrientationHorizontal;
    } else {
        [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", orientation];
    }

    if (orientation == MKLinearLayoutOrientationHorizontal) {
        rect.size.width = self.bounds.size.width;
    } else if (orientation == MKLinearLayoutOrientationVertical) {
        rect.size.height = self.bounds.size.height;
    } else {
        [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", orientation];
    }

    return rect;
}

- (CGFloat)lengthForItem:(MKLinearLayoutItem *)item orientation:(MKLinearLayoutOrientation)orientation overallWeight:(CGFloat)overallWeight overallLength:(CGFloat)overallLength contentLength:(CGFloat)contentLength
{
    float itemLength = [self pointsForOrientation:orientation fromItem:item];

    // Weight is used to achieve the arrangement in a linear layout horizontal or vertical.
    // A linear layout is not capable to arrange items both horizontal and vertical. If its necessary to align views, please use the corresponding alignment properties.
    // So just calculate the size by weight if the orientation fits.
    if (orientation == self.orientation) {
        if (item.weight != kMKLinearLayoutWeightInvalid) {
            float percent = item.weight / overallWeight;

            float boundsWithoutAbsoluteSizes = contentLength - overallLength;
            itemLength = boundsWithoutAbsoluteSizes * percent;
        }
    }
    return itemLength;
}

/**
 * Gathers the total weights and the total points in order to achieve relative layouting
 *
 * @discussion
 *
 * Obviously, the overall weight is used to calculate the total amount of relative layout items. The percentage of the space being used for an item
 * is the total space minus the available space.
 *
 * Available space is all the space that is not reserved for absolute sized layout items.
 *
 * Therefore it is also necessary to gather the total amount of space used by all layout items using the total size.
 */
- (void)calculateOverallWeight:(CGFloat *)overallWeight overallLength:(CGFloat *)overallPoints
{
    for (NSUInteger i = 0; i < self.items.count; i++) {
        MKLinearLayoutItem *item = self.items[i];
        if (item.weight != kMKLinearLayoutWeightInvalid) {
            *overallWeight += item.weight;
        } else {
            *overallPoints += [self pointsForOrientation:self.orientation fromItem:item];
        }
    }
}

/**
 * Extract flags for absolute sizes and replaces them with their point pendants
 *
 * @discussion
 *
 * Extract all your flags, such as match_parent and gets the length for it.
 */
- (CGFloat)pointsForOrientation:(MKLinearLayoutOrientation)orientation fromItem:(MKLinearLayoutItem *)item
{
    CGFloat points =  orientation == MKLinearLayoutOrientationHorizontal ? item.size.width : item.size.height;
    if (points == kMKLayoutItemSizeValueMatchParent) {
        points = [self lengthForOrientation:orientation];
    }
    return points;
}

- (CGFloat)lengthForOrientation:(MKLinearLayoutOrientation)orientation
{
    return [self lengthFromRect:self.bounds orientation:orientation];
}

- (CGFloat)lengthFromRect:(CGRect)rect orientation:(MKLinearLayoutOrientation)orientation
{
    switch (orientation) {
        case MKLinearLayoutOrientationHorizontal:
            return rect.size.width;
        case MKLinearLayoutOrientationVertical:
            return rect.size.height;

        default:
            break;
    }
    [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", orientation];
}

@end
