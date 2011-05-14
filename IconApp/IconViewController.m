//
//  IconViewController.m
//  IconView
//
//  Created by Marcus Crafter on 30/04/11.
//  Copyright 2011 Red Artisan. All rights reserved.
//

#import "IconViewController.h"
#import "IconView.h"

@implementation IconViewController

#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[IconView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
}

@end
