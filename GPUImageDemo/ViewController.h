//
//  ViewController.h
//  GPUImageDemo
//
//  Created by LGM on 15/6/25.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
@interface ViewController : UIViewController
{
    GPUImagePicture *sourcePicture;
    GPUImageOutput<GPUImageInput> *sepiaFilter, *sepiaFilter2;
    
    UISlider *imageSlider;
}



@end

