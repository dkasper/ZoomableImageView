@protocol ZoomableImageViewSingleTapDelegate <NSObject>
- (void)didSingleTap:(UITapGestureRecognizer *)recognizer;
@end

@interface ZoomableImageView : UIScrollView <UIScrollViewDelegate>

@property (weak, nonatomic) id<ZoomableImageViewSingleTapDelegate> singleTapDelegate;
- (void)resizeToContent:(CGSize)initialSize;
- (void)setupWithImage:(UIImage *)image;
@end
