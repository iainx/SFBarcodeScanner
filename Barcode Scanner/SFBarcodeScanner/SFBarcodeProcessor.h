//
//  SFBarcodeProcessor.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 07/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SFBarcodeProcessorDelegate.h"
#import "SFBarcodeTypes.h"

@class SFBarcodeScannerViewController;

@interface SFBarcodeProcessor : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
}

@property (assign, nonatomic) id<SFBarcodeProcessorDelegate> delegate;

+ (NSString *)stringFromType:(SFBarcodeType)type;

- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection;

@end
