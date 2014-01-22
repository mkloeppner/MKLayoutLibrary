//
//  MKLayoutTests.m
//  MKLayoutTests
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKLinearLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(MKLinearLayoutSpecification)

describe(@"MKLinearLayout", ^{
    
    __block MKLinearLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    __block UIView *subview5;
    __block UIView *subview6;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[MKLinearLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview4 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview5 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview6 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    
    // Absolute layouting
    it(@"should layout a view horinzontally with the specified width", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horinzontally with specified widths", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.points = 70.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.points);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.points);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout a view vertically with the specified width", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.points);
    });
    
    it(@"should layout two views vertically with specified widths", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.points = 70.0f;
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.points);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(layoutItem.points);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(layoutItem2.points);
        
    });
    
    it(@"should layout a view horizontally with margin specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views horizontally with margin specified", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.points = 70.0f;
        layoutItem2.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.points + 5.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.points - 10.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
    });
    
    it(@"should layout a view vertically with margin specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(layoutItem.points - 10.0f);
    });
    
    it(@"should layout two views vertically with margin specified", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.points = 70.0f;
        layoutItem2.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f );
        expect(subview1.frame.size.height).to.equal(layoutItem.points - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview2.frame.origin.y).to.equal(layoutItem.points + 5.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview2.frame.size.height).to.equal(layoutItem2.points - 10.0f);
        
    });
    
    // Relative layouting
    it(@"should layout a view horizontally with specified weight", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horizontally with specified weights", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horizontally with different weights", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width * 1.0f / 3.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width * 1.0f / 3.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width * 2.0f / 3.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout a view vertically with specified weight", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views vertically with specified weights", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f);
    });
    
    it(@"should layout two views vertically with different weights", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).beCloseToWithin(container.frame.size.height * 1.0f / 3.0f, 0.01f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.beCloseToWithin(container.frame.size.height * 1.0f / 3.0f, 0.01f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.beCloseToWithin(container.frame.size.height * 2.0f / 3.0f, 0.01f);
    });
    
    // Also test marigin
    it(@"should layout a view horizontally with specified weight and margin", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(5.0f);
        expect(subview1.frame.origin.y).to.equal(5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views horizontally with specified weights and different margins", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(5.0f);
        expect(subview1.frame.origin.y).to.equal(5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f + 10.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 10.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f - 20.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 20.0f);
    });
    
    it(@"should layout two views horizontally with different weights and different margins", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        layoutItem2.margin = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width * 1.0f / 3.0f - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width * 1.0f / 3.0f + 13.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 13.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width * 2.0f / 3.0f - 26.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 26.0f);
    });
    
    it(@"should layout a view vertically with specified weight and margin", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views vertically with specified weights and different margins", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 10.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f + 10.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 20.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f - 20.0f);
    });
    
    it(@"should layout two views vertically with different weights and different margins", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        layoutItem2.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).beCloseToWithin(container.frame.size.height * 1.0f / 3.0f - 10.0f, 0.01f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 10.0f);
        expect(subview2.frame.origin.y).to.beCloseToWithin(container.frame.size.height * 1.0f / 3.0f + 10.0f, 0.01f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 20.0f);
        expect(subview2.frame.size.height).to.beCloseToWithin(container.frame.size.height * 2.0f / 3.0f - 20.0f, 0.01f);
    });
    
    // Mixed layouting
    it(@"should layout two views horizontally with one absolute and the other with relative size specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.points);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.points);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout three views horizontally with one absolute and the others with relative size specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.points);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal((container.frame.size.width - layoutItem.points) / 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(subview2.frame.origin.x + subview2.frame.size.width);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal((container.frame.size.width - layoutItem.points) / 2.0f);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout three views horizontally with one absolute and the others with different relative sizes specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 2.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.points);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal((container.frame.size.width - layoutItem.points) * 1.0f / 3.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(subview2.frame.origin.x + subview2.frame.size.width);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal((container.frame.size.width - layoutItem.points) * 2.0f / 3.0f);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    // Sublayouts
    it(@"should layout views of a sublayout", ^{
        
        // Creation of sublayout
        MKLinearLayout *sublayout = [[MKLinearLayout alloc] initWithView:container];
        sublayout.orientation = MKLinearLayoutOrientationHorizontal;
        
        MKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview1];
        sublayoutItem.weight = 1.0f;
        // Ends creation
        
        MKLinearLayoutItem *layoutItem = [layout addSublayout:sublayout];
        layoutItem.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should apply margin of a sublayout", ^{
        
        UIEdgeInsets margin = UIEdgeInsetsMake(3.0f, 13.0f, 2.0f, 4.0f);
        
        // Creation of sublayout
        MKLinearLayout *sublayout = [[MKLinearLayout alloc] initWithView:container];
        sublayout.orientation = MKLinearLayoutOrientationHorizontal;
        
        MKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview1];
        sublayoutItem.weight = 1.0f;
        sublayoutItem.margin = margin;
        // Ends creation
        
        MKLinearLayoutItem *layoutItem = [layout addSublayout:sublayout];
        layoutItem.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + margin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + margin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - margin.left - margin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - margin.top - margin.bottom);
        
    });
    
    it(@"should layout the sublayout views with contentBounds of the sublayout item regarding position and available space", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.points = 30.0f;
        
        // Creation of sublayout
        MKLinearLayout *sublayout = [[MKLinearLayout alloc] initWithView:container];
        sublayout.orientation = MKLinearLayoutOrientationHorizontal;
        
        MKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview2];
        sublayoutItem.weight = 1.0f;
        // Ends creation
        
        MKLinearLayoutItem *layoutItem2 = [layout addSublayout:sublayout];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.points);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.points);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.points);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    
    it(@"should apply margin of a sublayout and its sublayout views margins with depth of hirary of 2", ^{
        
        UIEdgeInsets margin = UIEdgeInsetsMake(3.0f, 13.0f, 2.0f, 4.0f);
        UIEdgeInsets sublayoutViewMargin = UIEdgeInsetsMake(4.0f, 5.0f, 13.0f, 1.0f);
        
        // Creation of sublayout
        MKLinearLayout *sublayout = [[MKLinearLayout alloc] initWithView:container];
        sublayout.orientation = MKLinearLayoutOrientationHorizontal;
        
        MKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview1];
        sublayoutItem.weight = 1.0f;
        sublayoutItem.margin = sublayoutViewMargin;
        // Ends creation
        
        MKLinearLayoutItem *layoutItem = [layout addSublayout:sublayout];
        layoutItem.weight = 1.0f;
        layoutItem.margin = margin;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + margin.left + sublayoutViewMargin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + margin.top + sublayoutViewMargin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - margin.left - margin.right - sublayoutViewMargin.left - sublayoutViewMargin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - margin.top - margin.bottom - sublayoutViewMargin.top - sublayoutViewMargin.bottom);
        
    });
    
});

SpecEnd