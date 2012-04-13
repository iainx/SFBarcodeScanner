//
//  SFBarcodeProcessorDelegate.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 12/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBarcodeTypes.h"

@protocol SFBarcodeProcessorDelegate <NSObject>

- (void)barcodeDidScanType:(SFBarcodeType)type code:(NSString *)code;
- (void)barcodeScanError:(NSError *)error;

@end
