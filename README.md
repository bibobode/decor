##Decor is an iOS layout manager similar to CSS.

It is a category on UIView and provides every view with a ‘style’ property that can be manipulated to layout the view and its subviews.

###1. Add Decor to your project
###2. Import “D.h”

###3. Set the following on a parent view
    view.style.layoutType = LayoutTypeDecor

###4. Set width and height
	// Set view’s width to 50% of remaining width space
	view.style.width = percent(50);	
	
	// Set view’s height to a constant 100 pixels
	view.style.height = pixel(100);

	// Set view’s width to 100% of remaining width space minus 20 pixels
	view.style.width = [percent(100) subtract:pixel(20)];

###5. Set margin and padding
	// Set all margins to 10 pixels
	[view.style.margin setAll:pixel(10)];

	// Set left padding to 25 pixels
	view.style.padding.left = pixel(25);

###6. Line breaks

By default, every UIView has a line break of 0. This means the elements are aligned horizontally, relative to the previous sibling. 
	
/pic
	
Every view has an array of points to place each of its subviews (hereafter called the array).
	
Before the subviews are laid out, the array contains a single point called the default point (which is the origin, unless the view has padding, in which case it is the appropriately padded point).
	
When the first subview is added to a view, the subview is placed at the first point in the array. Once the subview is placed, its top-right and bottom-left corners are placed into the array.
	
Subsequent subviews are placed at the last point in the array, which is the top right corner of the last subview placed. By specifying a line break value, one can cause the view to be placed at other points in the array. 
	
For instance, a line break of 1 places the subview at the second-last point in the array, and a line break of 3 places the subview at the fourth-last point in the array. If such a point does not exist, the subview is placed at the default point.

###7. Absolute positioning

All subviews of a view using the LayoutTypeDecor layoutType are relatively positioned (i.e., position = relative). To specify absolute positioning, set the position to absolute.

Once absolute positioning is selected, set top, left, bottom, and right values of the style property.

    // Places the view against the left-most edge of its parent’s frame
    view.style.top = zero;

    // Places the view 10 pixels away from the right-most edge of its parent’s frame
    view.style.right = pixel(10);

    // Places the view away from the bottom-most edge of its parent’s frame a distance equal to 15 percent of its parent’s frame’s height
    view.style.bottom = percent(15);
