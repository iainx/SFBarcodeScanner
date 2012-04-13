//
//  SFBarcodeScannerViewControllerDelegate.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 12/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFBarcodeScannerViewControllerDelegate <NSObject>

- (void)scanCanceled;

@end
