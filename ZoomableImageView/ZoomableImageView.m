#import "ZoomableImageView+Private.h"
#import "UIGestureRecognizer+ConvinenceContructor.h"
#import "UIView+Alignment.h"

@implementation ZoomableImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScrollView];
        [self setupImageView];
    }

    return self;
}

- (void)awakeFromNib
{
    [self setupScrollView];
    [self setupImageView];
}

- (void)setupScrollView
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)setupWithImageURL:(NSURL *)url
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupPostImageLoaded) name:AsyncImageLoadDidFinish object:nil];
    [self setupPreImageLoaded];

    self.delegate = self;
    self.imageView.image = nil;
    self.imageView.imageURL = url;
}

- (void)setupWithImage:(UIImage *)image
{
    [self setupPreImageLoaded];

    self.delegate = self;
    self.imageView.image = image;

    [self setupPostImageLoaded];
}

- (void)setupImageView
{
    self.imageView = [[AsyncImageView alloc] initWithFrame:self.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
}

- (void)setupPreImageLoaded
{
    self.imageView.crossfadeImages = YES;

    [self setupZoomScale];
    [self setupGesturesForScrollView];
}

- (void)setupZoomScale
{
    if (!self.maximumZoomScale) {
        self.maximumZoomScale = LightboxMaximumZoomScale;
    }

    if (!self.minimumZoomScale) {
        self.minimumZoomScale = LightboxMinimumZoomScale;
    }
}

- (void)resetImage
{
    self.imageView.crossfadeImages = NO;
    self.imageView.image = nil;
}

- (void)setupGesturesForScrollView
{
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer gestureWithTarget:self action:@selector(userDidSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];

    UITapGestureRecognizer *doubleTap = [UITapGestureRecognizer gestureWithTarget:self action:@selector(userDidDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];

    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)setupPostImageLoaded
{
    [self.imageView sizeToFit];

    CGSize initialSize = CGSizeMake(self.frame.size.width, self.frame.size.height);

    [self resizeToContent:initialSize];

    self.zoomScale = self.minimumZoomScale;
    [self.imageView centerWithinSuperview];
}

- (void)userDidSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.singleTapDelegate didSingleTap:recognizer];
}

- (void)userDidDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGFloat desiredScale = [self doubleTapDestinationZoomScale];
    CGRect zoomRect = [self zoomRectForScale:desiredScale recognizer:recognizer];

    [self zoomToRect:zoomRect animated:YES];
    [self setZoomScale:desiredScale animated:YES];
}

- (CGRect)zoomRectForScale:(CGFloat)scale recognizer:(UITapGestureRecognizer *)recognizer
{
    CGPoint center = [recognizer locationInView:[self contentView]];
    return [self zoomRectForScale:scale withCenter:center];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;

    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;

    zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
    zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));

    return zoomRect;
}

- (CGFloat)doubleTapDestinationZoomScale
{
    CGFloat destinationZoomScale = self.maximumZoomScale;
    if (self.zoomScale == self.maximumZoomScale) {
        destinationZoomScale = self.minimumZoomScale;
    }
    return destinationZoomScale;
}

- (void)resizeToContent:(CGSize)initialSize;
{
    self.contentSize = [self contentView].frame.size;

    CGFloat minimumZoomScale = [self calculateMinimumZoomScale:initialSize];
    self.minimumZoomScale = minimumZoomScale;
}

- (UIView *)contentView
{
    return [self.delegate viewForZoomingInScrollView:self];
}

- (CGFloat)calculateMinimumZoomScale:(CGSize)initialSize
{
    self.zoomScale = 1.0;
    CGFloat heightScale = initialSize.height / self.contentSize.height;
    CGFloat widthScale = initialSize.width / self.contentSize.width;
    return MIN(widthScale, heightScale);
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scale <= self.minimumZoomScale) {
        [view centerWithinSuperview];
    }
}

@end
