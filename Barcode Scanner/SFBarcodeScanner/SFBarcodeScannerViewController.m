//
//  SFBarcodeScannerViewController.m
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

#import "SFBarcodeScannerViewController.h"
#import "SFBarcodeScannerView.h"
#import "SFBarcodeProcessor.h"
#import <AVFoundation/AVFoundation.h>

@interface SFBarcodeScannerViewController ()

@end

@implementation SFBarcodeScannerViewController

@synthesize processor = _processor;
@synthesize scannerView = _scannerView;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithProcessor:(SFBarcodeProcessor *)processor
{
    self = [self initWithNibName:@"SFBarcodeScannerViewController"
                          bundle:nil];
    self.processor = processor;
    
    return self;
}

- (void)dealloc
{
    SAFE_ARC_RELEASE (_processor);
    SAFE_ARC_SUPER_DEALLOC ();
}

- (void)loadView
{
    NSError *error = nil;
    [super loadView];

    [_scannerView setProcessor:self.processor withError:&error];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender
{
    if (_delegate) {
        [_delegate scanCanceled];
    }
}
@end
