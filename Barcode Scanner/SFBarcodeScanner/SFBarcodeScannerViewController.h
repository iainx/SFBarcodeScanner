//
//  SFBarcodeScannerViewController.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 07/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBarcodeScannerViewControllerDelegate.h"

@class SFBarcodeProcessor;
@class SFBarcodeScannerView;

@interface SFBarcodeScannerViewController : UIViewController

@property (assign, nonatomic) IBOutlet SFBarcodeScannerView *scannerView;
@property (SAFE_ARC_PROP_RETAIN , nonatomic) SFBarcodeProcessor *processor;
@property (assign) id<SFBarcodeScannerViewControllerDelegate> delegate;

- (id)initWithProcessor:(SFBarcodeProcessor *)processor;
@end
