# MKLayoutLibrary

MKLayoutLibrary has been written to allow iOS developers designing applications with
dynamic and complex layouts.

It provides some of the default layout functionality such as linear- and stack layout.

MKLayoutLibrary has been designed for being modular in terms of cooperating with UIKit and
being extensible with an easy API for writing custom layouts with custom layout properties.

## Usage

### Layout a view

There are two different approches to work with MKLayoutLibrary:

  - Create a custom view class (recommended)
  - Use the layout within a view controller

#### Custom class

MKLayout library has been designed to be used within UIView subclasses.

Here is an example of view with a vertical linear layout:

  __MKVerticalLayoutView.h:__
```obj-c
@interface MKVerticalLayoutView : UIView

@property (weak, nonatomic, readonly) UILabel *titleLabel;
@property (weak, nonatomic, readonly) UITextView *descriptionTextView;

@end
```

  __MKVerticalLayoutView.m:__

```obj-c
#import "MKVerticalLayoutView"

@interface MKVerticalLayoutView ()

@property (strong, nonatomic) MKLinearLayout *layout;

@property (weak, nonatomic) MKLinearLayoutItem *titleItem;
@property (weak, nonatomic) MKLinearLayoutItem *descriptionItem;

@end

@implementation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      _layout = [[MKLinearLayout alloc] init];
      _layout.view = self;
      _layout.orientation = MKLinearLayoutOrientationVertical;
      [self createLayout];
    }
    return self;
    }

- (void)createLayout
{
    // Adds the view to the layout and automatically to the layouts associated view
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleItem = [self.layout addSubview:titleLabel];

    // Once the layout items exists, it can be used to configure layout specifics such as paddings or sizes
    self.titleItem.padding = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);

    // Specifies 30 px height but streches the width to the full available layout size so it matches the parent view
    self.titleItem.size = CGSizeMake(kMKLayoutItemSizeValueMatchParent, 30.0f);

    UITextView *descriptionTextView = [[UITextView alloc] init];
    self.descriptionItem = [self.layout addSubview:descriptionTextView];

    // Specifies that the item gots all available left space.
    // Weight and size can be used at the same time. See MKLayoutItem and MKLinearLayoutItem for further details.
    self.titleItem.weight = 1.0f;
}

- (void)layoutSubviews
{
    [self.layout layout];
}

- (UILabel *)titleLabel
{
  return (UILabel *)self.titleLabelItem.view;
}

- (UITextView *)descriptionTextView
{
  return (UITextView *)self.descriptionItem.view;
}

@end
```

#### Any other compositon

MKLayout can be used in any context with UIKit but UIView's method - (void)layoutSubviews perfectly manages
the times when a view needs to be layouted. Of course - (void)layout can be called at any time.

### Sublayouts

MKLayout also support sublayouts:

```obj-c
// Create a layout instance
MKStackLayout *iconLayout = [[MKStackLayout alloc] init];

  UIImageView *backgroundPatternImage = [[UIImageView alloc] init];
  // Work with the sublayout as usal
  MKStackLayoutItem *backgroundPatternImage = [iconLayout addSubview:iconLayout];

// Add the sublayout to the root layout
MKLinearLayoutItem *iconLayoutLayoutItem = [self.layout addSublayout:iconLayout];
```

## Working with MKLayoutLibrary

MKLayoutLibrary is all about MKLayoutItem and its related subclasses.

Imagine a layout as a collection of boxes that can contain a single view or a layout identified as sublayout.
These boxes will be represent as MKLayoutItem. Every view or sublayout of these boxes will be
positioned by the layouts logic, so for example every boxes position follows another box frame
in a linear layout or they overlap in a stack layout.

However, MKLayoutItem specifies properties to adjust and configure the boxes layout behavior.  

All properties specified directly in MKLayoutItem will and needs to be supported by
every layout implementation. Layout specific subclasses of MKLayoutItem can provide per layout
configuration properties.

This section introduces the most important properties and their consistent behavior through all layouts.

### Size

A size is a specified length in a vertical and horizontal direction. It can only be affected by layout items padding.
Otherwise, the views size must match the layout items size.

This configuration of an item must result in a view.bounds.size with a width of 10 points and a height of 10 points:

```obj-c
item.size = CGSizeMake(10.0f, 10.0f);
```

### Padding

Padding is the only property that can and must affect the resulting bounds of a layout items view or sublayout.

The following configuration of an item must result in a view.bounds.size with a width of 9 points and height of 9 points:

```obj-c
item.size = CGSizeMake(10.0f, 10.0f);
item.padding = UIEdgeInsetsMake(0.0f, 0.0f, 1.0f, 1.0f); // Just shrink the view by reducing width and height
```

The following configuration of an item must result in a view.bounds.size with a width of 9 points and height of 9 points must move the resulting frame by x of 1 point and y of 1 point:

```obj-c
item.size = CGSizeMake(10.0f, 10.0f);
item.padding = UIEdgeInsetsMake(1.0f, 1.0f, 0.0f, 0.0f); // Shrink the view and move it by 1 point on x and y axis
```

The next configuration is a combination of the previous ones and must result in a view.bounds.size with a width of 8 points and height of 8 points and must move the resulting frame by x of 1 point and y of 1 point:

```obj-c
item.size = CGSizeMake(10.0f, 10.0f);
item.padding = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f); // Shrink the view on all edges and move it
```

#### Padding and Offset

Padding should be assumed to an inset to an outer box.
If it is just necessary to move a item view to ensure offsets to a specific edge layout item,
offsets could be a more reasonable approach.
Here an example:

This is a padding definition that should be represented as offset:
So these lines:

```obj-c
UIEdgeInsets padding = UIEdgeInsetsMake(0.0f, 0.0f, 5.0f, 5.0f); // Define padding to calculate the overall item size
item.gravity = MKLayoutGravityTop | MKLayoutGravityRight;
item.padding = padding;
item.size = CGSizeMake(30.0f + padding.right, 30.0f + padding.bottom); // Ensure the 30.0f pixels size by splitting up the padding definition
```

can be refactored to this:

```obj-c
item.gravity = MKLayoutGravityTop | MKLayoutGravityRight;
item.offset = UIOffsetMake(-5.0f, -5.0f);
```

### Gravity

As mentioned in the introduction, layout items represent boxes that can contain a view or sublayout.
These boxes tells the layout which space is reserved for the specified layout item. Depending on the layouts implementation,
the size of a view can be smaller than the layout items reserved space.
Therefore gravity makes sense and let us stick the view or sublayout of an item to an selected edge of the items box.

Therefore gravity is a bitmask and allows us to:

- Stick it to the center on a vertical axis
- Stick it to the center on a horizontal
- Stick it to the top
- Stick it to the left
- Stick it to the bottom
- Stick it to the right
- and all the reasonable combinations out of these options

Gravity must keep any offsets provided by layout items padding when moving the view or sublayout.

### Offset

After size, padding and gravity may have made changes to the views position (center), offset provides us to
move the resulting view or sublayout.

An offset helps us to specify a padding between edges of the item box and the items view.

This example moves the layout items view by 5 points to the right and bottom:

```obj-c
item.offset = UIOffsetMake(5.0f, 5.0f);
```

This example moves the layout items view by 5 points to the top and left:

```obj-c
item.offset = UIOffsetMake(-5.0f, -5.0f);
```

## Best practice

Here are some hints for working with MKLayout.

### View properties
MKLayout works best with keeping MKLayoutItems as properties instead of the subviews itself if you want to edit the layout
during runtime. So instead of:

```obj-c
@interface MKSampleLayoutView ()

@property (weak, nonatomic) UILabel *titleLabel;

@end
```

use:

```obj-c
@interface MKSampleLayoutView ()

@property (weak, nonatomic) MK<LayoutType>LayoutItem *<descriptiveName>Item;

@end
```

The items view or subview can be accessed via property:

__MKLayoutItem.h:__

```obj-c
- (UIView *)view
- (MKLayout *)sublayout;
```

For access some accessor methods can be written:

```obj-c
- (UILabel *)titleLabel
{
    return (UILabel *)self.titleLabelLayoutItem.subview;
}
```

## Interface design

MKLayoutLibrary is based on _MKLayout_ and _MKLayoutItem_. These two classes
provide the implementation for managing the layout hirarchy.
Here is a description of what these classes exactly do.

### MKLayoutItem

An layout item is an object containing a view or a partial-layout that will be managed by
any of the MKLayout subclasses. Additionally MKLayoutItem itself provides properties that all layouts needs to support.
MKLayoutItem can be subclassed to provided layout specific properties.

The name scheme for layout specific items looks like the following: MK<LayoutName>Item.
For example MKLinearLayout works together with MKLinearLayoutItem.

MKLayoutItem gets rid of the need to work with a specific UIView subclass which allows
developers to include MKLayoutLibrary as it is with just extending their existing code instead of
refactoring their base classes and structures.

Hint: Subclasses should include MKLayoutItem_SubclassAccessors to use the default initializer.

### MKLayout

MKLayout is the base class of MKLayoutLibrary and needs to be subclassed to provide
specific layout behavior. The class itself has the purpose the build up the object
tree of layout items and to translate this into the UIKits UIView hierarchy.

It is also a good place to share calculation code for layout purpose.
