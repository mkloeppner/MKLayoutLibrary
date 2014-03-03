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

    @interface MKVerticalLayoutView : UIView

    @property (weak, nonatomic, readonly) UILabel *titleLabel;
    @property (weak, nonatomic, readonly) UITextView *descriptionTextView;

    @end

  __MKVerticalLayoutView.m:__

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

          // Once the layout items exists, it can be used to configure layout specifics such as margins or sizes
          self.titleItem.margin = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);

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

#### Any other compositon

NKLayout can be used in any context with UIKit but UIView's method - (void)layoutSubviews perfectly manages
the times when a view needs to be layouted. Of course - (void)layout can be called at any time.

### Sublayouts

MKLayout also support sublayouts:

    // Create a layout instance
    MKStackLayout *iconLayout = [[MKStackLayout alloc] init];

      UIImageView *backgroundPatternImage = [[UIImageView alloc] init];
      // Work with the sublayout as usal
      MKStackLayoutItem *backgroundPatternImage = [iconLayout addSubview:iconLayout];

    // Add the sublayout to the root layout
    MKLinearLayoutItem *iconLayoutLayoutItem = [self.layout addSublayout:iconLayout];

### Best practice

Here are some hints for working with MKLayout.

#### View properties
MKLayout works best with keeping MKLayoutItems as properties instead of the subviews itself if you want to edit the layout
during runtime. So instead of:

    @interface MKSampleLayoutView ()

    @property (weak, nonatomic) UILabel *titleLabel;

    @end

use:

    @interface MKSampleLayoutView ()

    @property (weak, nonatomic) MK<LayoutType>LayoutItem *<descriptiveName>Item;

    @end

The items view or subview can be accessed via property:

__MKLayoutItem.h:__

    - (UIView *)view
    - (MKLayout *)sublayout;

For access some accessor methods can be written:

    - (UILabel *)titleLabel
    {
        return (UILabel *)self.titleLabelLayoutItem.subview;
    }

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

## Roadmap

Until version 1.0 MKLayoutLibrary is under rapid development which means, that the API
can slightly changed until that. However, here is a list of features planned for
Version 1.0.

### Flow-Layout

Linear layout is rally useful and makes sense for static contents or scroll views but
flow layouts should provide dynamic line breaks if following items doesn't fit into
into the left space for the current line. This results into container size changes
that needs to be supported especially for the planned WRAP_CONTENT feature.

### WRAP_CONTENT

It is also planned to specify sizes that matches their contents. As layout items
can contain sublayout it is necessary to provide MKLayout with pre-calculations
for the overall layout size.

### XML Support

There are plans for including a markup language for layouts.
