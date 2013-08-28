#import "UIGestureRecognizer+ConvinenceContructor.h"

@implementation UIGestureRecognizer (ConvinenceContructor)

+ (instancetype)gestureWithTarget:(id)target action:(SEL)action
{
    return [[self alloc] initWithTarget:target action:action];
}

@end
