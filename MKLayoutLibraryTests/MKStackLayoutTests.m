//
//  MKStackLayoutTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKStackLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(MKStackLayoutSpecification)

describe(@"MKStackLayout", ^{
    
    __block MKStackLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[MKStackLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    it(@"should stack a view", ^{
        
        [layout addSubview:subview1];
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should stack two views", ^{
        
        [layout addSubview:subview1];
        [layout addSubview:subview2];
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
        expect(0.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] view]);
        expect(subview2).to.equal([layout.items[1] view]);
        
    });
    
    it(@"should insert a margin for a view its specified", ^{
        
        MKLayoutItem *layoutItem1 = [layout addSubview:subview1];
        layoutItem1.margin = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x + 5.0f);
        expect(0.0f).to.equal(subview1.frame.origin.y + 5.0f);
        expect(container.frame.size.width - 10.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 10.0f).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should insert different margins for different views", ^{
        
        MKLayoutItem *layoutItem1 = [layout addSubview:subview1];
        MKLayoutItem *layoutItem2 = [layout addSubview:subview2];
        
        layoutItem1.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layoutItem2.margin = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x + 10.0f);
        expect(0.0f).to.equal(subview1.frame.origin.y + 10.0f);
        expect(container.frame.size.width - 20.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f).to.equal(subview1.frame.size.height);
        
        expect(0.0f + 15.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f + 15.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width - 30.0f).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height - 30.0f).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] view]);
        expect(subview2).to.equal([layout.items[1] view]);
        
    });
    
    it(@"should layout sublayouts in stack layout", ^{
        
        MKStackLayout *sublayout = [[MKStackLayout alloc] initWithView:container];
        [sublayout addSubview:subview1];
        [layout addSublayout:sublayout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should apply margin of sublayout", ^{
        
        MKStackLayout *sublayout = [[MKStackLayout alloc] initWithView:container];
        MKLayoutItem *layoutItem1 = [sublayout addSubview:subview1];
        layoutItem1.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        [layout addSublayout:sublayout];
        
        expect(0.0f + 10.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 10.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 20.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should apply margin with a depth of hirarchy of two", ^{
        
        MKStackLayout *stackLayout = [[MKStackLayout alloc] initWithView:container];
        MKLayoutItem *layoutItem1 = [stackLayout addSubview:subview1];
        MKLayoutItem *layoutItem2 = [layout addSublayout:stackLayout];
        
        layoutItem1.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layoutItem2.margin = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        [layout layout];
        
        expect(0.0f + 10.0f + 15.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 10.0f + 15.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 20.0f - 30.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f - 30.0f).to.equal(subview1.frame.size.height);
        
        
    });
    
});

SpecEnd