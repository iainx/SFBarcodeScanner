//
//  SFBarcodeTypes.h
//  Barcode Scanner
//
//  Created by Iain Holmes on 12/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#ifndef Barcode_Scanner_SFBarcodeTypes_h
#define Barcode_Scanner_SFBarcodeTypes_h

extern NSString * const SFBarcodeProcessorErrorDomain;

typedef enum SFBarcodeProcessorError {
    SFBarcodeProcessorErrorNone = 0,
    SFBarcodeProcessorErrorUnknown,
    SFBarcodeProcessorErrorReaderException,
    SFBarcodeProcessorErrorIllegalArgument,
} SFBarcodeProcessorError;

typedef enum SFBarcodeType {
    SFBarcodeQRCode = 0,
    SFBarcodeDataMatrix,
    SFBarcodeUPC_E,
    SFBarcodeUPC_A,
    SFBarcodeEAN_8,
    SFBarcodeEAN_13,
    SFBarcodeCode_128,
    SFBarcodeCode_39,
    SFBarcodeITF,
    SFBarcodeUnknown
} SFBarcodeType;

#endif
