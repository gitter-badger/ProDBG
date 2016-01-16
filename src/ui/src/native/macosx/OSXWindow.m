#import "OSXWindow.h"
#import "OSXWindowFrameView.h"

@implementation WindowDelegate

- (void)windowDidResize:(NSNotification *)notification
{
    const NSRect contentRect = [[window contentView] frame];

    printf("diidResize\n");

    prodbg_set_window_size((int)contentRect.size.width, (int)contentRect.size.height);
}

- (id)initWithWindow:(OSXWindow*)initWindow
{
    self = [super init];
    if (self != nil)
        window = initWindow;

    return self;
}

@end


@implementation OSXWindow

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]
		removeObserver:self];
	[super dealloc];
}

- (void)setContentView:(NSView *)aView
{
	if ([childContentView isEqualTo:aView])
		return;

	printf("set content view\n");
	
	NSRect bounds = [self frame];
	bounds.origin = NSZeroPoint;

	OSXWindowFrameView* frameView = [super contentView];
	if (!frameView) {
		frameView = [[[OSXWindowFrameView alloc] initWithFrame:bounds] autorelease];
		[super setContentView:frameView];
	}
	
	if (childContentView)
		[childContentView removeFromSuperview];

	NSRect t = [self contentRectForFrameRect:bounds];

	childContentView = aView;
	[childContentView setFrame:[self contentRectForFrameRect:bounds]];
	[childContentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[frameView addSubview:childContentView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setContentSize:(NSSize)newSize
{
	NSSize sizeDelta = newSize;
	NSSize childBoundsSize = [childContentView bounds].size;
	sizeDelta.width -= childBoundsSize.width;
	sizeDelta.height -= childBoundsSize.height;
	
	OSXWindowFrameView *frameView = [super contentView];
	NSSize newFrameSize = [frameView bounds].size;
	newFrameSize.width += sizeDelta.width;
	newFrameSize.height += sizeDelta.height;

	[super setContentSize:newFrameSize];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)flagsChanged:(NSEvent *)event
{
	const uint32_t flags = [event modifierFlags];

	// Left Shift
	key_callback(rust_data, 0x38, flags == 0x20102 ? 1 : 0);
	
	// RightShift
	key_callback(rust_data, 0x3c, flags == 0x20104 ? 1 : 0);

	// Left Ctrl
	key_callback(rust_data, 0x3b, flags == 0x40101 ? 1 : 0);

	// Right Ctrl
	key_callback(rust_data, 0x3b, flags == 0x42101 ? 1 : 0);

	// Left Alt
	key_callback(rust_data, 0x3a, flags == 0x80120 ? 1 : 0);

	// Right Super
	key_callback(rust_data, 0x3d, flags == 0x80140  ? 1 : 0);

	// Left Super
	key_callback(rust_data, 0x37, flags == 0x100108 ? 1 : 0);

	// Right Super
	key_callback(rust_data, 0x36, flags == 0x100110 ? 1 : 0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)keyDown:(NSEvent *)event
{
	// Cmd+Q always closes app
    if ([event.characters.uppercaseString isEqualToString:@"Q"] && ([event modifierFlags] & NSCommandKeyMask)) {
        [self performClose:self];
        return;
    }

	if (key_callback) {
		key_callback(rust_data, [event keyCode], 1);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)keyUp:(NSEvent *)event
{
	if (key_callback) {
		key_callback(rust_data, [event keyCode], 0);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)mainWindowChanged:(NSNotification *)aNotification
{
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)windowWillClose:(NSNotification *)notification 
{
	should_close = true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)windowShouldClose:(id)sender
{
	should_close = true;
	return TRUE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSView *)contentView
{
	return childContentView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)canBecomeMainWindow
{
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSRect)contentRectForFrameRect:(NSRect)windowFrame
{
	windowFrame.origin = NSZeroPoint;
	return NSInsetRect(windowFrame, 0, 0);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateSize 
{

	/*
	OSXWindowFrameView* frameView = [super contentView];
	if (frameView)
	{
		frameView->width = width; 
		frameView->height = height; 
		frameView->draw_buffer = draw_buffer; 
		frameView->scale = scale;
	}
	*/
}

@end
