//
//  SFBarcodeScannerView.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 12/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class SFBarcodeProcessor;

@interface SFBarcodeScannerView : UIView {
    AVCaptureSession *captureSession;
}

- (BOOL)setProcessor:(SFBarcodeProcessor *)processor withError:(NSError **)error;
- (void)startScanning;
- (void)stopScanning;

@end
