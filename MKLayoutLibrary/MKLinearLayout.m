//
//  MKLinearLayout.m
//  MKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKLinearLayout.h"

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
    self.bounds = bounds;
    
    float currentPos = 0.0f;
    float overallWeight = 0.0f;
    float overallLength = 0.0f;
    
    [self calculateOverallWeight:&overallWeight overallLength:&overallLength];
    
    float contentLength = [self lengthForOrientation:self.orientation];
    
    for (int i = 0; i < self.items.count; i++) {
        
        MKLinearLayoutItem *item = self.items[i];
        
        CGRect rect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
        
        // Apply current position]
        if (self.orientation == MKLinearLayoutOrientationHorizontal) {
            rect.origin.x = currentPos;
        } else {
            rect.origin.y = currentPos;
        }
        
        // Calculate absolute size
        rect.size.width = [self lengthForItem:item orientation:MKLinearLayoutOrientationHorizontal overallWeight:overallWeight overallLength:overallLength contentLength:contentLength];
        rect.size.height = [self lengthForItem:item orientation:MKLinearLayoutOrientationVertical overallWeight:overallWeight overallLength:overallLength contentLength:contentLength];
        
        // Apply offset for recursive layout calls in order to achieve sublayouts
        rect.origin.x += bounds.origin.x;
        rect.origin.y += bounds.origin.y;
        
        currentPos += [self lengthFromRect:rect orientation:self.orientation];
        
        // Apply the margin in order to achive spacings around the item view
        rect = UIEdgeInsetsInsetRect(rect, item.margin);
        
        if (item.subview) {
            item.subview.frame = rect;
        } else if (item.sublayout) {
            [item.sublayout layoutBounds:rect];
        }
    
    }
    
    self.bounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)lengthForItem:(MKLinearLayoutItem *)item orientation:(MKLinearLayoutOrientation)orientation overallWeight:(CGFloat)overallWeight overallLength:(CGFloat)overallLength contentLength:(CGFloat)contentLength
{
    float itemLength = [self pointsForOrientation:orientation fromItem:item];
    if (orientation == self.orientation) {
        if (item.weight != kMKLinearLayoutWeightInvalid) {
            float percent = item.weight / overallWeight;
            
            float boundsWithoutAbsoluteSizes = contentLength - overallLength;
            itemLength = boundsWithoutAbsoluteSizes * percent;
        }
    }
    return itemLength;
}

- (void)calculateOverallWeight:(CGFloat *)overallWeight overallLength:(CGFloat *)overallPoints
{
    for (int i = 0; i < self.items.count; i++) {
        MKLinearLayoutItem *item = self.items[i];
        if (item.weight != kMKLinearLayoutWeightInvalid) {
            *overallWeight += item.weight;
        } else {
            *overallPoints += [self pointsForOrientation:self.orientation fromItem:item];
        }
    }
}

// TODO: Return the real points. item.size can contain flags as match_parent
- (CGFloat)pointsForOrientation:(MKLinearLayoutOrientation)orientation fromItem:(MKLinearLayoutItem *)item
{
    CGFloat points =  orientation == MKLinearLayoutOrientationHorizontal ? item.size.width : item.size.height;
    if (points == kMKLinearLayoutSizeValueMatchParent) {
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
            break;
        case MKLinearLayoutOrientationVertical:
            return rect.size.height;
            
        default:
            break;
    }
    [NSException raise:@"Unknown state exception" format:@"Can't calculate the length for orientation %i", orientation];
}

@end
