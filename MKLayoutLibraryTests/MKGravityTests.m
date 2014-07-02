//
//  MKGravityTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKGravity.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"

SpecBegin(MKGravitySpecification)

describe(@"MKGravity", ^{
    
    __block MKGravity *gravity;
    __block CGRect rect;
    __block CGRect itemRect;
    
    beforeEach(^{
        rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
        itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        gravity = [[MKGravity alloc] initWithCGRect:itemRect parent:rect];
    });
    
    it(@"should not apply gravity if gravity it set to MKLayoutGravityNone", ^{
        
        [gravity moveByGravity:MKLayoutGravityNone];
        
        expect(gravity.CGRect).to.equal(itemRect);
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally (center)", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, 0.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect vertically (center)", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterVertical];
        
        expect(gravity.CGRect).to.equal(CGRectMake(0.0f, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally and vertically (center)", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterHorizontal | MKLayoutGravityCenterVertical];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally and keep the vertical offset", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, itemRect.origin.y, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect vertically and keep the horizontal offset", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterVertical];
        
        expect(gravity.CGRect).to.equal(CGRectMake(itemRect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to topleft", ^{
        
        [gravity moveByGravity:MKLayoutGravityTop | MKLayoutGravityLeft];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to topright", ^{
        
        [gravity moveByGravity:MKLayoutGravityTop | MKLayoutGravityRight];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to top and horizontalcenter", ^{
        
        [gravity moveByGravity:MKLayoutGravityTop | MKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottomleft", ^{
        
        [gravity moveByGravity:MKLayoutGravityBottom | MKLayoutGravityLeft];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.origin.x, rect.size.height - itemRect.size.height, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottomright", ^{
        
        
        [gravity moveByGravity:MKLayoutGravityBottom | MKLayoutGravityRight];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.size.height - itemRect.size.height + rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottom and horizontalcenter", ^{
        
        [gravity moveByGravity:MKLayoutGravityBottom | MKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.size.height - itemRect.size.height + rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to vericalcenter left", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterVertical | MKLayoutGravityLeft];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to verticalcenter right", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterVertical | MKLayoutGravityRight];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to horizontalcenter top", ^{
        
        [gravity moveByGravity:MKLayoutGravityCenterHorizontal | MKLayoutGravityTop];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to horizontalcenter bottom", ^{
        
        
        [gravity moveByGravity:MKLayoutGravityCenterHorizontal | MKLayoutGravityBottom];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.size.height - itemRect.size.height, itemRect.size.width, itemRect.size.height));
    });
    
    
});

SpecEnd