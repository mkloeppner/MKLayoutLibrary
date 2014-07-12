//
//  MKRect.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKGravity.h"
#import "MKCGRectAdditions.h"

@interface MKGravity ()

@property (assign, nonatomic, readwrite) CGRect CGRect;
@property (assign, nonatomic, readwrite) CGRect parentRect;

@property (assign, nonatomic, readwrite) MKLayoutGravity gravity;

@end

@implementation MKGravity

- (instancetype)initWithCGRect:(CGRect)rect parent:(CGRect)parentRect
{
    self = [super init];
    if (self) {
        self.CGRect = rect;
        self.parentRect = parentRect;
    }
    return self;
}

- (void)moveByGravity:(MKLayoutGravity)gravity {
    
    if (MKLayoutGravityNone == gravity) {
        return;
    }
    self.gravity = gravity;
    [self moveHorizontalByGravity];
    [self moveVerticalByGravity];
    
}

- (void)moveHorizontalByGravity {
    if ([self shouldBeCenteredHorizontally]) {
        [self moveRectToHorizontalCenter];
    } else {
        [self moveToHorizontalEdgeByGravity];
    }
}

- (void)moveVerticalByGravity {
    if ([self shouldBeCenteredVertically]) {
        [self moveRectToVerticalCenter];
    } else {
        [self moveToVerticalEdgeByGravity];
    }
}

- (void)moveToHorizontalEdgeByGravity {
    if ([self shouldBeMovedToTheLeft]) {
        [self moveRectToLeftOfParent];
    } else if ([self shouldBeMovedToTheRight]) {
        [self moveRectToRightOfParent];
    }
}

- (void)moveToVerticalEdgeByGravity {
    if ([self shouldBeMovedToTheTop]) {
        [self moveRectToTopOfParent];
    } else if ([self shouldBeMovedToTheBottom]) {
        [self moveRectToBottomOfParent];
    }
}

- (BOOL)shouldBeCenteredHorizontally {
    return (self.gravity & MKLayoutGravityCenterHorizontal) == MKLayoutGravityCenterHorizontal;
}

- (void)moveRectToHorizontalCenter {
    self.CGRect = CGRectMoveHorizontallyToCenterWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeCenteredVertically {
    return (self.gravity & MKLayoutGravityCenterVertical) == MKLayoutGravityCenterVertical;
}

- (void)moveRectToVerticalCenter{
    self.CGRect = CGRectMoveVerticallyToCenterWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheLeft {
    return (self.gravity & MKLayoutGravityLeft) == MKLayoutGravityLeft;
}

- (void)moveRectToLeftOfParent{
    self.CGRect =  CGRectMoveToLeftWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheRight {
    return (self.gravity & MKLayoutGravityRight) == MKLayoutGravityRight;
}

- (void)moveRectToRightOfParent{
    self.CGRect = CGRectMoveToRightWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheTop {
    return (self.gravity & MKLayoutGravityTop) == MKLayoutGravityTop;
}

- (void)moveRectToTopOfParent{
    self.CGRect =  CGRectMoveToTopWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheBottom {
    return (self.gravity & MKLayoutGravityBottom) == MKLayoutGravityBottom;
}

- (void)moveRectToBottomOfParent{
    self.CGRect =  CGRectMoveToBottomWithinRect(self.CGRect, self.parentRect);
}

@end
