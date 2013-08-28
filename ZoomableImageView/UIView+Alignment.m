#import "UIView+Alignment.h"

@implementation UIView (Alignment)

- (void)centerVertically
{
    CGRect frame = self.frame;
    CGRect superviewFrame = self.superview.frame;
    CGFloat yOffset = (superviewFrame.size.height - frame.size.height) / 2;
    frame.origin.y = yOffset;
    self.frame = frame;
}

- (void)centerHorizontally
{
    CGRect frame = self.frame;
    CGRect superviewFrame = self.superview.frame;
    CGFloat xOffset = (superviewFrame.size.width - frame.size.width) / 2;
    frame.origin.x = xOffset;
    self.frame = frame;
}

- (void)centerWithinSuperview
{
    [self centerVertically];
    [self centerHorizontally];
}

- (void)clearSubviews
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
