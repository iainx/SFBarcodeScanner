//
//  SFBarcodeScannerView.m
//  Barcode Scanner
//
//  Created by Iain Holmes on 12/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//
// Contains code from PhoneGap

/*
 * PhoneGap is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright 2011 Matt Kane. All rights reserved.
 * Copyright (c) 2011, IBM Corporation
 *
 * PhoneGap also includes code from the zxing ( http://code.google.com/p/zxing/ )
 * project, which is licensed under the Apache License 2.0
 * ( http://www.apache.org/licenses/LICENSE-2.0 ).
 */

#import "SFBarcodeScannerView.h"
#import "SFBarcodeProcessor.h"

@implementation SFBarcodeScannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    SAFE_ARC_RELEASE (captureSession);
    SAFE_ARC_SUPER_DEALLOC ();
}

- (BOOL)setProcessor:(SFBarcodeProcessor *)processor
           withError:(NSError **)error
{
    captureSession = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //if (!device) return @"unable to obtain video capture device";
    
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:error];
    if (!input) {
        return NO;
    }
    
    //AVCaptureVideoDataOutput* output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    
    //if (!output) return @"unable to obtain video capture output";
    
    NSDictionary* videoOutputSettings = [NSDictionary
                                         dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                         forKey:(id)kCVPixelBufferPixelFormatTypeKey
                                         ];
    
    output.alwaysDiscardsLateVideoFrames = YES;
    output.videoSettings = videoOutputSettings;
    
    [output setSampleBufferDelegate:processor
                              queue:dispatch_get_main_queue()];
    
    if (![captureSession canSetSessionPreset:AVCaptureSessionPresetMedium]) {
        //return @"unable to preset medium quality video capture";
    }
    
    captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    if ([captureSession canAddInput:input]) {
        [captureSession addInput:input];
    }
    else {
        //return @"unable to add video capture device input to session";
    }
    
    if ([captureSession canAddOutput:output]) {
        [captureSession addOutput:output];
    }
    else {
        //return @"unable to add video capture output to session";
    }
    
    // setup capture preview layer
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = self.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    if ([previewLayer isOrientationSupported]) {
        [previewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    [self.layer addSublayer:previewLayer];

    [self addSubview:[self buildOverlayView]];
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#define RETICLE_SIZE    500.0f
#define RETICLE_WIDTH    10.0f
#define RETICLE_OFFSET   60.0f
#define RETICLE_ALPHA     0.4f

- (UIView *)buildOverlayView
{
    UIView *reticleView;
    UIImage* result;
    
    CGRect bounds = [self bounds];
    CGFloat rootViewHeight = CGRectGetHeight(bounds);
    CGFloat rootViewWidth  = CGRectGetWidth(bounds);
    
    UIGraphicsBeginImageContext(CGSizeMake(RETICLE_SIZE, RETICLE_SIZE));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* color = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:RETICLE_ALPHA];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, RETICLE_WIDTH);
    CGContextBeginPath(context);
    CGFloat lineOffset = RETICLE_OFFSET+(0.5*RETICLE_WIDTH);
    CGContextMoveToPoint(context, lineOffset, RETICLE_SIZE/2);
    CGContextAddLineToPoint(context, RETICLE_SIZE-lineOffset, 0.5*RETICLE_SIZE);
    CGContextStrokePath(context);
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    reticleView = [[UIImageView alloc] initWithImage:result];
    
    CGFloat minAxis = MIN(rootViewHeight, rootViewWidth);
    
    CGRect rectArea = CGRectMake(0.5 * (rootViewWidth  - minAxis),
                                 0.5 * (rootViewHeight - minAxis),
                                 minAxis, minAxis);
    [reticleView setFrame:rectArea];
    [reticleView setOpaque:NO];
    [reticleView setContentMode:UIViewContentModeScaleAspectFit];
    [reticleView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin
     | UIViewAutoresizingFlexibleRightMargin
     | UIViewAutoresizingFlexibleTopMargin
     | UIViewAutoresizingFlexibleBottomMargin];
    
    return SAFE_ARC_AUTORELEASE (reticleView);
}

- (void)startScanning
{
    [captureSession startRunning];
}

- (void)stopScanning
{
    [captureSession stopRunning];
}

@end
