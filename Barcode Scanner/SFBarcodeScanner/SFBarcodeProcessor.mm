//
//  SFBarcodeProcessor.m
//  Barcode Scanner
//
//  Created by Iain Holmes on 07/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

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

#import "SFBarcodeProcessor.h"
#import "SFBarcodeScannerViewController.h"
#import "zxing-all-in-one.h"

@implementation SFBarcodeProcessor

@synthesize delegate = _delegate;

NSString * const SFBarcodeProcessorErrorDomain = @"com.sleepfive.BarcodeProcessor";

+ (NSString *)stringFromType:(SFBarcodeType)type
{
    switch (type) {
        case SFBarcodeDataMatrix:
            return @"Data Matrix";
            
        case SFBarcodeQRCode:
            return @"QR Code";
            
        case SFBarcodeITF:
            return @"ITF";
            
        case SFBarcodeEAN_8:
            return @"EAN 8";
            
        case SFBarcodeEAN_13:
            return @"EAN 13";
            
        case SFBarcodeUPC_A:
            return @"UPC A";
            
        case SFBarcodeUPC_E:
            return @"UPC E";
            
        case SFBarcodeCode_39:
            return @"Code 39";
            
        case SFBarcodeCode_128:
            return @"Code 128";
            
        default:
            return @"Unknown";
    }
}

- (id)init
{
    self = [super init];

    return self;
}

//--------------------------------------------------------------------------

- (void)barcodeScanSucceeded:(NSString*)text 
                        type:(SFBarcodeType)type {
    if (_delegate) {
        [_delegate barcodeDidScanType:type code:text];
    }
}

- (void)barcodeScanError:(SFBarcodeProcessorError)code 
                  reason:(NSString *)reason
{
    NSString *desc;
    
    if (_delegate == nil) {
        return;
    }
    
    switch (code) {            
        case SFBarcodeProcessorErrorReaderException:
            desc = @"Reader exception";
            break;
            
        case SFBarcodeProcessorErrorIllegalArgument:
            desc = @"Illegal argument";
            break;
            
        case SFBarcodeProcessorErrorUnknown:
            desc = @"Unknown error";
            break;
            
            
        case SFBarcodeProcessorErrorNone:
        default:
            desc = @"No error";
            break;
    }
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:desc, NSLocalizedDescriptionKey, reason, NSLocalizedFailureReasonErrorKey, nil];
    NSError *err = [NSError errorWithDomain:SFBarcodeProcessorErrorDomain
                                       code:code
                                   userInfo:userInfo];
    
    [_delegate barcodeScanError:err];
}

//--------------------------------------------------------------------------
// this method gets sent the captured frames
//--------------------------------------------------------------------------
- (void)captureOutput:(AVCaptureOutput*)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection*)connection {

    
    
    using namespace zxing;
    
    // LuminanceSource is pretty dumb; we have to give it a pointer to
    // a byte array, but then can't get it back out again.  We need to
    // get it back to free it.  Saving it in imageBytes.
    uint8_t* imageBytes;
    
    try {
        DecodeHints decodeHints;
        decodeHints.addFormat(BarcodeFormat_QR_CODE);
        //decodeHints.addFormat(BarcodeFormat_DATA_MATRIX);
        decodeHints.addFormat(BarcodeFormat_UPC_E);
        decodeHints.addFormat(BarcodeFormat_UPC_A);
        decodeHints.addFormat(BarcodeFormat_EAN_8);
        decodeHints.addFormat(BarcodeFormat_EAN_13);
        //decodeHints.addFormat(BarcodeFormat_CODE_128);
        //decodeHints.addFormat(BarcodeFormat_CODE_39);
        //            decodeHints.addFormat(BarcodeFormat_ITF);   causing crashes
        
        // here's the meat of the decode process
        Ref<LuminanceSource>   luminanceSource   ([self getLuminanceSourceFromSample: sampleBuffer imageBytes:&imageBytes]);

        Ref<Binarizer>         binarizer         (new HybridBinarizer(luminanceSource));
        Ref<BinaryBitmap>      bitmap            (new BinaryBitmap(binarizer));
        Ref<MultiFormatReader> reader            (new MultiFormatReader());
        Ref<Result>            result            (reader->decode(bitmap, decodeHints));
        Ref<String>            resultText        (result->getText());
        BarcodeFormat          formatVal =       result->getBarcodeFormat();
        SFBarcodeType          type    =       [self typeFromFormat:formatVal];
        
        
        const char* cString      = resultText->getText().c_str();
        NSString *resultString = [NSString stringWithCString:cString 
                                                    encoding:NSUTF8StringEncoding];
        [self barcodeScanSucceeded:resultString type:type];
        
    }
    catch (zxing::ReaderException &rex) {
        NSString *errStr = [NSString stringWithCString:rex.what()
                                              encoding:NSUTF8StringEncoding];
        [self barcodeScanError:SFBarcodeProcessorErrorReaderException reason:errStr];
    }
    catch (zxing::IllegalArgumentException &iex) {
        NSString *errStr = [NSString stringWithCString:iex.what()
                                              encoding:NSUTF8StringEncoding];
        [self barcodeScanError:SFBarcodeProcessorErrorIllegalArgument reason:errStr];
    }
    catch (...) {
        [self barcodeScanError:SFBarcodeProcessorErrorUnknown reason:@"Unknown"];
    }
    
    //        NSTimeInterval timeElapsed  = [NSDate timeIntervalSinceReferenceDate] - timeStart;
    //        NSLog(@"decoding completed in %dms", (int) (timeElapsed * 1000));
    
    // free the buffer behind the LuminanceSource
    if (imageBytes) {
        free(imageBytes);
    }
}

- (SFBarcodeType)typeFromFormat:(zxing::BarcodeFormat)format {
    switch (format) {
        case zxing::BarcodeFormat_QR_CODE:
            return SFBarcodeQRCode;
        case zxing::BarcodeFormat_DATA_MATRIX:
            return SFBarcodeDataMatrix;
        case zxing::BarcodeFormat_UPC_E:
            return SFBarcodeUPC_E;
        case zxing::BarcodeFormat_UPC_A:
            return SFBarcodeUPC_A;
        case zxing::BarcodeFormat_EAN_8:
            return SFBarcodeEAN_8;
        case zxing::BarcodeFormat_EAN_13:
            return SFBarcodeEAN_13;
        case zxing::BarcodeFormat_CODE_128:
            return SFBarcodeCode_128;
        case zxing::BarcodeFormat_CODE_39:
            return SFBarcodeCode_39;
        case zxing::BarcodeFormat_ITF:
            return SFBarcodeITF;
        default:
            return SFBarcodeUnknown;
    }
}

//--------------------------------------------------------------------------
// convert capture's sample buffer (scanned picture) into the thing that
// zxing needs.
//--------------------------------------------------------------------------
- (zxing::Ref<zxing::LuminanceSource>) getLuminanceSourceFromSample:(CMSampleBufferRef)sampleBuffer imageBytes:(uint8_t**)ptr {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    size_t   bytesPerRow =            CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t   width       =            CVPixelBufferGetWidth(imageBuffer);
    size_t   height      =            CVPixelBufferGetHeight(imageBuffer);
    uint8_t* baseAddress = (uint8_t*) CVPixelBufferGetBaseAddress(imageBuffer);
    
    // only going to get 90% of the min(width,height) of the captured image
    size_t    greyWidth  = 9 * MIN(width, height) / 10;
    uint8_t*  greyData   = (uint8_t*) malloc(greyWidth * greyWidth);
    
    // remember this pointer so we can free it later
    *ptr = greyData;
    
    if (!greyData) {
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        throw new zxing::ReaderException("out of memory");
    }
    
    size_t offsetX = (width  - greyWidth) / 2;
    size_t offsetY = (height - greyWidth) / 2;
    
    // pixel-by-pixel ...
    for (size_t i=0; i<greyWidth; i++) {
        for (size_t j=0; j<greyWidth; j++) {
            // i,j are the coordinates from the sample buffer
            // ni, nj are the coordinates in the LuminanceSource
            // in this case, there's a rotation taking place
            size_t ni = greyWidth-j;
            size_t nj = i;
            
            size_t baseOffset = (j+offsetY)*bytesPerRow + (i + offsetX)*4;
            
            // convert from color to grayscale
            // http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            size_t value = 0.11 * baseAddress[baseOffset] +
            0.59 * baseAddress[baseOffset + 1] +
            0.30 * baseAddress[baseOffset + 2];
            
            greyData[nj*greyWidth + ni] = value;
        }
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    using namespace zxing;
    
    Ref<LuminanceSource> luminanceSource (
                                          new GreyscaleLuminanceSource(greyData, greyWidth, greyWidth, 0, 0, greyWidth, greyWidth)
                                          );
    
    return luminanceSource;
}

@end
