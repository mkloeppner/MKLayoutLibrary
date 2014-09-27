//
//  MKLayoutTests.m
//  MKLayoutTests
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "MKLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"

@interface MKLayout (APIAccessors)

- (void)layoutItemWantsRemoval:(MKLayoutItem *)item;

@property (weak, nonatomic, readwrite) MKLayoutItem *item;

@end

SpecBegin(MKLayoutSpecification)

describe(@"MKLayout", ^{
    
    __block MKLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[MKLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview4 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    
    // View management
    it(@"should associate the specified container", ^{
        expect(layout.view).to.equal(container);
    });
    
    it(@"should add a view to the associated view of the layout when added to it", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        expect(container.subviews.count).to.equal(1);
        expect(container.subviews[0]).to.equal(childView);
    });
    
    it(@"should add multiple views to the associated view of the layout when added to it", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        UIView *childView2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView2];
        
        expect(container.subviews.count).to.equal(2);
        expect(container.subviews[0]).to.equal(childView);
        expect(container.subviews[1]).to.equal(childView2);
    });
    
    it(@"should return an layout reference object to identify the childViews associated layout parameters", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(layoutItem).toNot.beNil;
        expect(layoutItem.subview).to.equal(childView);
        expect(layoutItem.layout).to.equal(layout);
    });
    
    it(@"should remove view from layout", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(layout.view.subviews.count).to.equal(0);
        expect(layoutItem.layout).to.beNil;
        
    });
    
    it(@"should add a view of a sublayout with adding this sublayout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        MKLayout *sublayout = [[MKLayout alloc] initWithView:container];
        MKLayoutItem *layoutItem = [sublayout addSubview:childView];
        [layout addSublayout:sublayout];
        
        expect(layoutItem).toNot.beNil;
        expect(layoutItem.subview).to.equal(childView);
        expect(layoutItem.layout).to.equal(sublayout);
        
    });
    
    it(@"should remove a view of a sublayout with removing this sublayout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        MKLayout *sublayout = [[MKLayout alloc] initWithView:container];
        [sublayout addSubview:childView];
        MKLayoutItem *sublayoutItem = [layout addSublayout:sublayout];
        
        [sublayoutItem removeFromLayout];
        
        expect(layout.view.subviews.count).to.equal(0);
        expect(sublayoutItem.layout).to.beNil;
        
    });
    
    // Item management
    it(@"should cache the layout item for a added view to allow to access information at any time", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(layoutItem);
    });
    
    it(@"should remove a layout item from cache with removing the view", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(layout.items.count).to.equal(0);
    });
    
    it(@"should provide an empty method to override", ^{
        [layout layoutBounds:layout.view.bounds];
    });
    
    it(@"should return a specified userInfo for meta data", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        MKLayoutItem *layoutItem = [layout addSubview:childView];
        NSDictionary *userInfo = @{@"name": @"layoutItem"};
        layoutItem.userInfo = userInfo;
        
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(layoutItem);
        expect(layoutItem.userInfo).to.equal(userInfo);
    });
    
    // Helper
    it(@"should provide a method to insert a subview at a specific index", ^{
        
        MKLayoutItem *item = [layout insertSubview:subview1 atIndex:0];
        
        expect(layout.items.count).to.equal(1);
        
        expect(item).to.equal(layout.items[0]);
        
    });
    
    it(@"should provide a method to insert a subview bofore an other item", ^{
        
        MKLayoutItem *item = [layout addSubview:subview1];
        MKLayoutItem *item2 = [layout insertSubview:subview2 atIndex:0];
        
        expect(layout.items.count).to.equal(2);
        
        expect(item).to.equal(layout.items[1]);
        expect(item2).to.equal(layout.items[0]);
        
    });
    
    it(@"should provide a method to insert a sublayout behind an other item with the following index", ^{
        
        MKLayoutItem *item = [layout addSubview:subview1];
        MKLayoutItem *item2 = [layout insertSubview:subview2 atIndex:layout.items.count];
        
        expect(layout.items.count).to.equal(2);
        
        expect(item).to.equal(layout.items[0]);
        expect(item2).to.equal(layout.items[1]);
        
    });
    
    it(@"should provide a method to be able to remove items via index", ^{
        
        [layout addSubview:subview1];
        
        expect(layout.items.count).to.equal(1);
        
        [layout removeLayoutItemAtIndex:0];
        
        expect(layout.items.count).to.equal(0);
        
    });
    
    it(@"should provide a method to remove any layout item at a specific position in the layout hirarchy", ^{
        
        MKLayoutItem *item = [layout addSubview:subview1];
        [layout addSubview:subview2];
        MKLayoutItem *item3 = [layout addSubview:subview3];
        
        expect(layout.items.count).to.equal(3);
        
        [layout removeLayoutItemAtIndex:1];
        
        expect(layout.items.count).to.equal(2);
        
        expect(item).to.equal(layout.items[0]);
        expect(item3).to.equal(layout.items[1]);
        
    });
    
    it(@"should provide a method to remove a layout item", ^{
        
        MKLayoutItem *item = [layout addSubview:subview1];
        
        expect(layout.items.count).to.equal(1);
        
        [layout removeLayoutItem:item];
        
        expect(layout.items.count).to.equal(0);
        
    });
    
    it(@"should provide a method to add a layout item", ^{
        
        MKLayoutItem *item = [layout addSubview:subview1];
        [item removeFromLayout];
        
        expect(layout.items.count).to.equal(0);
        
        [layout addLayoutItem:item];
        
        expect(layout.items.count).to.equal(1);
        
    });
    
    it(@"should provide a method to append layout item at the end of the layout", ^{
        
        MKLayoutItem *item = [layout addSubview:subview1];
        [layout addSubview:subview2];
        [layout addSubview:subview3];
        [layout addSubview:subview4];
        
        expect(layout.items.count).to.equal(4);
        
        [item removeFromLayout];
        
        expect(layout.items.count).to.equal(3);
        
        [layout addLayoutItem:item];
        
        expect(layout.items.count).to.equal(4);
        
        MKLayoutItem *itemAtLastPosition = layout.items[layout.items.count - 1];
        
        expect(itemAtLastPosition).to.equal(item);
        
    });
    
    it(@"should provide a method to delete all child items", ^{
        
        [layout addSubview:subview1];
        [layout addSubview:subview2];
        [layout addSubview:subview3];
        [layout addSubview:subview4];
        
        expect(layout.items.count).to.equal(4);
        
        [layout clear];
        
        expect(layout.items.count).to.equal(0);
        
    });
    
    it(@"should automatically remove a layout item from an old layout with adding it to another one", ^{
        
        UIView *container2 = [[UIView alloc] init];
        MKLayout *layout2 = [[MKLayout alloc] initWithView:container2];
        
        MKLayoutItem *item = [layout2 addSubview:subview1];
        
        [layout addLayoutItem:item];
        
        // Is it removed from the old layout
        expect(layout2.items.count).to.equal(0);
        
        // Is it inserted in the new layout
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(item);
    
        // Does it changed it superview
        expect(item.subview.superview).to.equal(container);
    
        
    });
    
    it(@"should not retain a view its view in order to prevent retain cycles", ^{
        
        __weak UIView *view = nil;
        __strong MKLayout *layout = [[MKLayout alloc] init];
        
        @autoreleasepool {
            UIView *localReleasedView = [[UIView alloc] init];
            localReleasedView = [[UIView alloc] init];
            view = localReleasedView;
            
            layout.view = view;
        }
        
        expect(layout.view).to.equal(nil);
        
    });
    
    it(@"should not retain its item since its holding the layout", ^{
        
        __weak MKLayoutItem *weakLayoutItem = nil;
        __strong MKLayout *layout = [[MKLayout alloc] init];
        
        @autoreleasepool {
            MKLayoutItem *layoutItem = [[MKLayoutItem alloc] init];
            weakLayoutItem = layoutItem;
            
            layout.item = weakLayoutItem;
        }
        
        expect(layout.item).to.equal(nil);
        
    });
    
    
});

SpecEnd