//
//  MKRect.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "MKGravity.h"

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
    if ((self.gravity & MKLayoutGravityCenterHorizontal) == MKLayoutGravityCenterHorizontal) {
        [self moveRectToHorizontalCenter];
    } else {
        [self moveToHorizontalEdgeByGravity];
    }
}

- (void)moveVerticalByGravity {
    if ((self.gravity & MKLayoutGravityCenterVertical) == MKLayoutGravityCenterVertical) {
        [self moveRectToVerticalCenter];
    } else {
        [self moveToVerticalEdgeByGravity];
    }
}

- (void)moveToHorizontalEdgeByGravity {
    if ((self.gravity & MKLayoutGravityLeft) == MKLayoutGravityLeft) {
        [self moveRectToLeftOfParent];
    } else if ((self.gravity & MKLayoutGravityRight) == MKLayoutGravityRight) {
        [self moveRectToRightOfParent];
    }
}

- (void)moveToVerticalEdgeByGravity {
    if ((self.gravity & MKLayoutGravityTop) == MKLayoutGravityTop) {
        [self moveRectToTopOfParent];
    } else if ((self.gravity & MKLayoutGravityBottom) == MKLayoutGravityBottom) {
        [self moveRectToBottomOfParent];
    }
}

- (CGRect)moveRectToHorizontalCenter
{
    self.CGRect = CGRectMake(self.parentRect.size.width / 2.0f - self.CGRect.size.width / 2.0f + self.parentRect.origin.x,
                      self.CGRect.origin.y,
                      self.CGRect.size.width,
                      self.CGRect.size.height);
    return CGRectZero;
}

- (CGRect)moveRectToVerticalCenter
{
    self.CGRect = CGRectMake(self.CGRect.origin.x,
                      self.parentRect.size.height / 2.0f - self.CGRect.size.height / 2.0f + self.parentRect.origin.y,
                      self.CGRect.size.width,
                      self.CGRect.size.height);
        return CGRectZero;
}

- (CGRect)moveRectToLeftOfParent
{
    self.CGRect =  CGRectMake(self.parentRect.origin.x,
                      self.CGRect.origin.y,
                      self.CGRect.size.width,
                      self.CGRect.size.height);
        return CGRectZero;
}

- (CGRect)moveRectToRightOfParent
{
    self.CGRect =  CGRectMake(self.parentRect.origin.x + self.parentRect.size.width - self.CGRect.size.width,
                      self.CGRect.origin.y,
                      self.CGRect.size.width,
                      self.CGRect.size.height);
        return CGRectZero;
}

- (CGRect)moveRectToTopOfParent
{
    self.CGRect =  CGRectMake(self.CGRect.origin.x,
                      self.parentRect.origin.y,
                      self.CGRect.size.width,
                      self.CGRect.size.height);
        return CGRectZero;
}

- (CGRect)moveRectToBottomOfParent
{
    self.CGRect =  CGRectMake(self.CGRect.origin.x,
                      self.parentRect.origin.y + self.parentRect.size.height - self.CGRect.size.height,
                      self.CGRect.size.width,
                      self.CGRect.size.height);
        return CGRectZero;
}

@end
