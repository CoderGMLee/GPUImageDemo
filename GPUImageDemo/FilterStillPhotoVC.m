//
//  FilterStillPhotoVC.m
//  GPUImageDemo
//
//  Created by GM on 16/7/22.
//  Copyright © 2016年 GM. All rights reserved.
//

#import "FilterStillPhotoVC.h"

#define KContainerHei (SCREEN_HEI * 0.8)
#define KFocusViewWid 80
@interface FilterStillPhotoVC ()
{
    GPUImageStillCamera *stillCamera;
    GPUImageGammaFilter * filter;
    GPUImageView *filterView;
    UIView * _containerView;
    UIButton * _actionBtn;
    UIView * _animationView;
}
@end

@implementation FilterStillPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:@"StillPhoto"];
    [self config];
    [self initCamera];
}
- (void)config{
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavHei, SCREEN_WID, KContainerHei)];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_containerView];

    _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionBtn.frame = CGRectMake(0, _containerView.bottom + 10, SCREEN_WID * 0.5, (SCREEN_HEI - _containerView.height - 10) * 2 / 3);
    [_actionBtn setTitle:@"action" forState:UIControlStateNormal];
    [_actionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_actionBtn setCenterX:SCREEN_WID / 2];
    [_actionBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_actionBtn];

}
- (void)initCamera{
    stillCamera = [[GPUImageStillCamera alloc]
                   initWithSessionPreset:AVCaptureSessionPresetPhoto
                   cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    filter = [[GPUImageGammaFilter alloc] init];
    filter.gamma = 2.0;
    [stillCamera addTarget:filter];
    filterView = [[GPUImageView alloc] initWithFrame:_containerView.bounds];
    filterView.fillMode = kGPUImageFillModeStretch;
    [filter addTarget:filterView];
    [_containerView addSubview:filterView];

    _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFocusViewWid, KFocusViewWid)];
    _animationView.layer.borderWidth = 2;
    _animationView.layer.borderColor = [UIColor yellowColor].CGColor;
    _animationView.hidden = YES;
    [filterView addSubview:_animationView];

    [self setFocusPoint];
}
- (void)action:(UIButton *)btn{
    [self filterStillPhoto];
}
- (void)filterStillPhoto{
    if (stillCamera.captureSession.isRunning) {
        [stillCamera stopCameraCapture];
        return;
    }
    [stillCamera startCameraCapture];
}
- (void)setFocusPoint{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGuesture:)];
    [filterView setUserInteractionEnabled:YES];
    [filterView addGestureRecognizer:tap];
}
//聚焦
- (void)focusGuesture:(UITapGestureRecognizer *)tap{
    CGPoint location = [tap locationInView:filterView];
    if ([stillCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [_animationView setHidden:NO];
        _animationView.center = location;

        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 1;
        animation.values = @[@(1),@(0.5),@(0.5)];
        animation.keyTimes = @[@(0),@(0.75),@(1)];
        animation.delegate = self;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_animationView.layer addAnimation:animation forKey:@"animaiton"];

        [stillCamera.inputCamera lockForConfiguration:nil];
        [stillCamera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
        [stillCamera.inputCamera setFocusPointOfInterest:location];
        [stillCamera.inputCamera unlockForConfiguration];
    }
}
- (void)takePic{
    [stillCamera capturePhotoAsSampleBufferWithCompletionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {

    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_animationView setHidden:YES];
    [_animationView.layer removeAllAnimations];
}
@end
