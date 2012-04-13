//
//  SFViewController.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 07/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBarcodeProcessorDelegate.h"
#import "SFBarcodeScannerViewControllerDelegate.h"

@class SFBarcodeScannerViewController;
@class SFBarcodeScannerView;

@interface SFViewController : UIViewController <SFBarcodeProcessorDelegate, SFBarcodeScannerViewControllerDelegate> {
    SFBarcodeScannerViewController *scanController;
    SFBarcodeScannerView *scannerView;
}

@property (assign) IBOutlet UILabel *codeLabel;
@property (assign) IBOutlet UILabel *typeLabel;

- (IBAction)scanBarcode:(id)sender;

- (void)barcodeDidScanType:(SFBarcodeType)type code:(NSString *)code;
- (void)barcodeScanError:(NSError *)error;

- (void)scanCanceled;

@end
