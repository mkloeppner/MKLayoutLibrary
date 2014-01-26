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
#import "MKLinearLayoutSeparatorImpl.h"


SpecBegin(MKLinearLayoutSpecification)

describe(@"MKLinearLayout", ^{
    
    __block MKLinearLayout *layout;
    __block UIView *container;
    __block MKLinearLayoutSeparatorImpl *separatorDefinition;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        separatorDefinition = nil;
        layout = [[MKLinearLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    it(@"should layout a view with the specified size", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, 40.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
    });
    
    
    // Absolute layouting
    it(@"should layout a view horinzontally with the specified width", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horinzontally with specified widths", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(70.0f, kMKLayoutItemSizeValueMatchParent);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout two views horinzontally with specified sizes and uses outer gravity", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, 10.0f);
        layoutItem.gravity = MKLayoutGravityCenterVertical;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(70.0f, 20.0f);
        layoutItem2.gravity = MKLayoutGravityCenterVertical;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(container.bounds.size.height / 2.0f - layoutItem.size.height / 2.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(container.bounds.size.height / 2.0f - layoutItem2.size.height / 2.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.size.width);
        expect(subview2.frame.size.height).to.equal(layoutItem2.size.height);
        
    });
    
    it(@"should layout a view vertically with the specified width", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 30.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
    });
    
    it(@"should layout two views vertically with specified widths", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 30.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 70.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(layoutItem.size.height);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(layoutItem2.size.height);
        
    });
    
    it(@"should apply outer margin", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
        layout.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 10.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 10.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 20.0f);
    });
    
    it(@"should apply outer margin and item margin", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        layoutItem.margin = UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        
        layout.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 10.0f + 3.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 10.0f + 3.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width - 6.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 20.0f - 6.0f);
    });
    
    it(@"should layout a view horizontally with margin specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views horizontally with margin specified", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);;
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(70.0f, kMKLayoutItemSizeValueMatchParent);
        layoutItem2.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width + 5.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.size.width - 10.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
    });
    
    it(@"should layout a view vertically with margin specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 30.0f);
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height - 10.0f);
    });
    
    it(@"should layout two views vertically with margin specified", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 30.0f);
        layoutItem.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 70.0f);
        layoutItem2.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f );
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview2.frame.origin.y).to.equal(layoutItem.size.height + 5.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview2.frame.size.height).to.equal(layoutItem2.size.height - 10.0f);
        
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
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout three views horizontally with one absolute and the others with relative size specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) / 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(subview2.frame.origin.x + subview2.frame.size.width);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) / 2.0f);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout three views horizontally with one absolute and the others with different relative sizes specified", ^{
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 2.0f;
        
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) * 1.0f / 3.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(subview2.frame.origin.x + subview2.frame.size.width);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) * 2.0f / 3.0f);
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
        layoutItem.size = CGSizeMake(30.0f, kMKLayoutItemSizeValueMatchParent);
        
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
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.size.width);
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
    
    it(@"should add paddings in order to keep space for separators between views if separatorDelegate has been set for horizontal layout with setting size by weight", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f - 2.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f + 2.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f - 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should add paddings in order to keep space for separators between three views if separatorDelegate has been set for horizontal layout with setting size by weight", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 3.0f - 2.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 3.0f + 2.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 3.0f - 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(container.frame.size.width / 3.0f * 2.0f + 2.0f);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal(container.frame.size.width / 3.0f - 2.0f);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should add paddings in order to keep space for separators between views if separatorDelegate has been set for vertical layout with setting size by weight", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f - 2.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f + 2.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f - 2.0f);
        
    });
    
    it(@"should add paddings in order to keep space for separators between three views if separatorDelegate has been set for vertical layout with setting size by weight", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        container.frame = CGRectMake(0.0f, 0.0f, 300.0f, 300.f);
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 3.0f - 2.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 3.0f + 2.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 3.0f - 2.0f);
        
        expect(subview3.frame.origin.x).to.equal(0.0f);
        expect(subview3.frame.origin.y).to.equal(container.frame.size.height / 3.0f * 2.0f + 2.0f);
        expect(subview3.frame.size.width).to.equal(container.frame.size.width);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height / 3.0f - 2.0f);
        
    });
    
    
    it(@"should add paddings in order to keep space for separators between views if separatorDelegate has been set for horizontal layout with setting size by weight and using margin", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f - 2.0f - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - layoutItem.margin.top - layoutItem.margin.bottom);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f + 2.0f + layoutItem.margin.left);
        expect(subview2.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f - 2.0f - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - layoutItem.margin.top - layoutItem.margin.bottom);
        
    });
    
    it(@"should add paddings in order to keep space for separators between three views if separatorDelegate has been set for horizontal layout with setting size by weight and using margin", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        layoutItem3.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 3.0f - 2.0f - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - layoutItem.margin.top - layoutItem.margin.bottom);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 3.0f + 2.0f + layoutItem.margin.left);
        expect(subview2.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 3.0f - 2.0f - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - layoutItem.margin.top - layoutItem.margin.bottom);
        
        expect(subview3.frame.origin.x).to.equal(container.frame.size.width / 3.0f * 2.0f + 2.0f + layoutItem.margin.left);
        expect(subview3.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview3.frame.size.width).to.equal(container.frame.size.width / 3.0f - 2.0f - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height - layoutItem.margin.top - layoutItem.margin.bottom);
        
    });
    
    it(@"should add paddings in order to keep space for separators between views if separatorDelegate has been set for vertical layout with setting size by weight and using margin", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f - 2.0f - layoutItem.margin.top - layoutItem.margin.bottom);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f + 2.0f + layoutItem.margin.top);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f - 2.0f - layoutItem.margin.top - layoutItem.margin.bottom);
        
    });
    
    it(@"should add paddings in order to keep space for separators between three views if separatorDelegate has been set for vertical layout with setting size by weight and using margin", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        MKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        layoutItem3.margin = UIEdgeInsetsMake(4.0f, 6.0f, 3.0f, 2.0f);
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        container.frame = CGRectMake(0.0f, 0.0f, 300.0f, 300.f);
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + layoutItem.margin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 3.0f - 2.0f - layoutItem.margin.top - layoutItem.margin.bottom);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 3.0f + 2.0f + layoutItem.margin.top);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 3.0f - 2.0f - layoutItem.margin.top - layoutItem.margin.bottom);
        
        expect(subview3.frame.origin.x).to.equal(0.0f + layoutItem.margin.left);
        expect(subview3.frame.origin.y).to.equal(container.frame.size.height / 3.0f * 2.0f + 2.0f + layoutItem.margin.top);
        expect(subview3.frame.size.width).to.equal(container.frame.size.width - layoutItem.margin.left - layoutItem.margin.right);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height / 3.0f - 2.0f - layoutItem.margin.top - layoutItem.margin.bottom);
        
    });
    
    it(@"should create separator information horizontally", ^{
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(separatorDefinition.separators.count).to.equal(1);
        
        NSDictionary *separator1 = separatorDefinition.separators[0];
        NSValue *separator1RectValue = separator1[kSeparatorsDictionaryKeyRect];
        CGRect separator1Rect = separator1RectValue.CGRectValue;
        
        expect(separator1Rect.origin.x).to.equal(container.frame.size.width / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator1Rect.origin.y).to.equal(0.0f);
        expect(separator1Rect.size.width).to.equal(separatorDefinition.separatorThickness);
        expect(separator1Rect.size.height).to.equal(container.frame.size.height);
        
        NSNumber *orientation = separator1[kSeparatorsDictionaryKeyType];
        expect([orientation intValue]).to.equal(MKLinearLayoutOrientationVertical);
    });
    
    it(@"should create separators information, the rect and the type vertically", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(separatorDefinition.separators.count).to.equal(1);
        
        NSDictionary *separator1 = separatorDefinition.separators[0];
        NSValue *separator1RectValue = separator1[kSeparatorsDictionaryKeyRect];
        CGRect separator1Rect = separator1RectValue.CGRectValue;
        
        expect(separator1Rect.origin.x).to.equal(0.0f);
        expect(separator1Rect.origin.y).to.equal(container.frame.size.height / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator1Rect.size.width).to.equal(container.frame.size.width);
        expect(separator1Rect.size.height).to.equal(separatorDefinition.separatorThickness);
        
        NSNumber *orientation = separator1[kSeparatorsDictionaryKeyType];
        expect([orientation intValue]).to.equal(MKLinearLayoutOrientationHorizontal);
    });
    
    it(@"should create separators information, the rect and the type with margin", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        [layout layout];
        
        expect(separatorDefinition.separators.count).to.equal(1);
        
        NSDictionary *separator1 = separatorDefinition.separators[0];
        NSValue *separator1RectValue = separator1[kSeparatorsDictionaryKeyRect];
        CGRect separator1Rect = separator1RectValue.CGRectValue;
        
        expect(separator1Rect.origin.x).to.equal(0.0f);
        expect(separator1Rect.origin.y).to.equal(container.frame.size.height / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator1Rect.size.width).to.equal(container.frame.size.width);
        expect(separator1Rect.size.height).to.equal(separatorDefinition.separatorThickness);
        
        NSNumber *orientation = separator1[kSeparatorsDictionaryKeyType];
        expect([orientation intValue]).to.equal(MKLinearLayoutOrientationHorizontal);
    });
    
    it(@"should create separators information, the rect and the type with margin and layout margin", ^{
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.margin = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
        
        MKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.margin = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationVertical;
        layout.margin = UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        [layout layout];
        
        expect(separatorDefinition.separators.count).to.equal(1);
        
        NSDictionary *separator1 = separatorDefinition.separators[0];
        NSValue *separator1RectValue = separator1[kSeparatorsDictionaryKeyRect];
        CGRect separator1Rect = separator1RectValue.CGRectValue;
        
        expect(separator1Rect.origin.x).to.equal(0.0f);
        expect(separator1Rect.origin.y).to.equal(container.frame.size.height / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator1Rect.size.width).to.equal(container.frame.size.width);
        expect(separator1Rect.size.height).to.equal(separatorDefinition.separatorThickness);
        
        NSNumber *orientation = separator1[kSeparatorsDictionaryKeyType];
        expect([orientation intValue]).to.equal(MKLinearLayoutOrientationHorizontal);
    });
    
    it(@"should create separator information with margin and layout margin for a layout hirarchy of two", ^{
        
        separatorDefinition = [MKLinearLayoutSeparatorImpl separatorWithSeparatorThickness:4.0f separatorIntersectionOffsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        
        MKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        MKLinearLayout *sublayout = [[MKLinearLayout alloc] initWithView:container];
        sublayout.separatorDelegate = separatorDefinition;
        sublayout.orientation = MKLinearLayoutOrientationVertical;
        
            MKLinearLayoutItem *layoutItem1 = [sublayout addSubview:subview2];
            layoutItem1.weight = 1.0f;
        
            MKLinearLayoutItem *layoutItem2 = [sublayout addSubview:subview3];
            layoutItem2.weight = 1.0f;
        
        MKLinearLayoutItem *layoutItemSublayout = [layout addSublayout:sublayout];
        layoutItemSublayout.weight = 1.0f;
        
        layout.separatorDelegate = separatorDefinition;
        layout.orientation = MKLinearLayoutOrientationHorizontal;
        [layout layout];
        
        expect(separatorDefinition.separators.count).to.equal(2);
        
        NSDictionary *separator1 = separatorDefinition.separators[0];
        NSValue *separator1RectValue = separator1[kSeparatorsDictionaryKeyRect];
        CGRect separator1Rect = separator1RectValue.CGRectValue;
        
        expect(separator1Rect.origin.x).to.equal(container.frame.size.width / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator1Rect.origin.y).to.equal(0.0f);
        expect(separator1Rect.size.width).to.equal(separatorDefinition.separatorThickness);
        expect(separator1Rect.size.height).to.equal(container.frame.size.height);
        
        NSNumber *orientation = separator1[kSeparatorsDictionaryKeyType];
        expect([orientation intValue]).to.equal(MKLinearLayoutOrientationVertical);
        
        NSDictionary *separator2 = separatorDefinition.separators[1];
        NSValue *separator2RectValue = separator2[kSeparatorsDictionaryKeyRect];
        CGRect separator2Rect = separator2RectValue.CGRectValue;
        
        expect(separator2Rect.origin.x).to.equal(container.frame.size.width / 2.0f + separatorDefinition.separatorThickness / 2.0f);
        expect(separator2Rect.origin.y).to.equal(container.frame.size.height / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator2Rect.size.width).to.equal(container.frame.size.width / 2.0f - separatorDefinition.separatorThickness / 2.0f);
        expect(separator2Rect.size.height).to.equal(separatorDefinition.separatorThickness);
        
        NSNumber *orientation2 = separator2[kSeparatorsDictionaryKeyType];
        expect([orientation2 intValue]).to.equal(MKLinearLayoutOrientationHorizontal);

        
        // TODO: Check vertical information
    });
    
});

SpecEnd