#import "AsyncImageView.h"
#import "ZoomableImageView.h"

CGFloat const LightboxMaximumZoomScale = 1.1f;
CGFloat const LightboxMinimumZoomScale = 0.33f;

@interface ZoomableImageView()

@property (strong, nonatomic) AsyncImageView *imageView;

- (void)userDidSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)userDidDoubleTap:(UITapGestureRecognizer *)recognizer;

@end