#include <substrate.h>
#include <UIKit/UIStatusBar.h>
#import <CoreGraphics/CoreGraphics.h>
#include <SpringBoard/SpringBoard.h>

%hook SpringBoard
%property (nonatomic, assign) UIWindow *noNotch; //add a new UIWindow property (Call it something unique so it doesnt mess with any other tweaks)
%property (nonatomic, assign) UIView *cutoutView; //add a new UIWindow property (I like to make properties)

- (void)applicationDidFinishLaunching:(UIApplication *)arg1
{
    CGRect wholeFrame = [UIScreen mainScreen].bounds; // Screen Boundries
    
    self.noNotch = [[UIWindow alloc] initWithFrame:wholeFrame]; //whole screen size goes to the window
    self.noNotch.userInteractionEnabled = NO; // Ensures that touches are passed through.
    self.noNotch.windowLevel = UIWindowLevelStatusBar-10; //make this be under the status bar
    self.noNotch.hidden = NO; //we don't want it hidden for whatever reason
    self.noNotch.backgroundColor = [UIColor blackColor]; // If we stop here we will only see a black screen. Good battery life tho.
    
    self.cutoutView = [[UIView alloc] initWithFrame:CGRectMake(0,32,wholeFrame.size.width,wholeFrame.size.height-32]; //the notch view (The 32px is the height of the Notch
    self.cutoutView.layer.compositingFilter = @"destOut"; // Special filter used in iOS 11 to cut out stuff.
    [self.cutoutView.layer setMasksToBounds:YES]; //^^
    self.cutoutView.layer.cornerRadius = 39; // Corner Radius of iPhone X
    [self.noNotch addSubview:self.cutoutView]; // Add our cutout view.
    
    %orig; //make SpringBoard do whatever it was gonna do before we kicked in and stole the notch
}


%end


