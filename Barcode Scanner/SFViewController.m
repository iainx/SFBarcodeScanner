//
//  SFViewController.m
//  Barcode Scanner
//
//  Created by Iain Holmes on 07/04/2012.
//  Copyright (c) 2012 Sleep(5). All rights reserved.
//

#import "SFViewController.h"
#import "SFBarcodeScannerView.h"
#import "SFBarcodeScannerViewController.h"
#import "SFBarcodeProcessor.h"

@interface SFViewController ()

@end

@implementation SFViewController

@synthesize typeLabel;
@synthesize codeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)scanBarcode:(id)sender
{
    SFBarcodeProcessor *processor = [[SFBarcodeProcessor alloc] init];
    
    [processor setDelegate:self];
    scanController = [[SFBarcodeScannerViewController alloc] initWithProcessor:processor];
    [scanController setDelegate:self];
    
    
    [self presentModalViewController:scanController animated:YES];
    
    scannerView = [scanController scannerView];
    [scannerView startScanning];
}

- (void)scanCanceled
{
    [scannerView stopScanning];
    [self dismissModalViewControllerAnimated:YES];
    
    scanController = nil;
}

- (void)barcodeScanError:(NSError *)error
{
    // Seem to get a lot of Reader exceptions simple because there's no barcode present
    // So we'll just ignore errors
    NSLog(@"Error: %@, %@", [error localizedDescription], 
          [error localizedFailureReason]);
}

- (void)barcodeDidScanType:(SFBarcodeType)type code:(NSString *)code
{
    [codeLabel setText:code];
    [typeLabel setText:[SFBarcodeProcessor stringFromType:type]];
    
    [scannerView stopScanning];
    [self dismissModalViewControllerAnimated:YES];
    
    scanController = nil;
}
@end
