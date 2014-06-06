
#import "GPUImage.h"
#import "NCFilters.h"

@class NCVideoCamera;

@protocol IFVideoCameraDelegate <NSObject>

- (void)IFVideoCameraWillStartCaptureStillImage:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraDidFinishCaptureStillImage:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraDidSaveStillImage:(NCVideoCamera *)videoCamera;
- (BOOL)canIFVideoCameraStartRecordingMovie:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraWillStartProcessingMovie:(NCVideoCamera *)videoCamera;
- (void)IFVideoCameraDidFinishProcessingMovie:(NCVideoCamera *)videoCamera;
@end

@interface NCVideoCamera : GPUImageVideoCamera


@property (strong, readonly) GPUImageView *gpuImageView_HD;
@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, unsafe_unretained, readonly) BOOL isRecordingMovie;

/**
 *  addSubView展示即可
 */
@property (strong, nonatomic) GPUImageView *gpuImageView;

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithFrame:(CGRect)frame;


/**
 *  选择不同的滤镜类型
 */
- (void)switchFilter:(NCFilterType)type;


/**
 *  快速实例化对象
 *
 *  @param frame    gpuImageView的frame
 *  @param rawImage 需要进行滤镜处理的image对象
 */
+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage;

@end
