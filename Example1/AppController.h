//
//  AppController.h
//  Example1
//
//  Created by Lars Steiger on 2/28/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <FsprgEmbeddedStore/FsprgEmbeddedStore.h>


@interface AppController : NSObject <FsprgEmbeddedStoreDelegate> {
	IBOutlet WebView* storeView;
	FsprgEmbeddedStoreController *storeController;
}

- (FsprgEmbeddedStoreController *)storeController;
- (void)setStoreController:(FsprgEmbeddedStoreController *)aStoreController;

- (IBAction)load:(id)sender;

@end
