#import "delegate.h"

void Window_buildMenu();

extern "C" {
void prodbg_destroy();
void prodbg_application_launched();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ProDBGAppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication*)sender {
    (void)sender;
    return NSTerminateNow;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    Window_buildMenu();
    prodbg_application_launched();

    (void)aNotification;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction) buttonClicked:(id)sender {
    (void)sender;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillTerminate:(NSNotification*)aNotification {
    (void)aNotification;
    prodbg_destroy();
}

@end

