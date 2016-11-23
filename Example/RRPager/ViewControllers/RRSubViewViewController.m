//
//  RRMainViewController.m
//  RRPager
//
//  Created by Rutger Nijhuis on 21/11/2016.
//  Copyright © 2016 Rutger Nijhuis. All rights reserved.
//

#import "RRSubViewViewController.h"
#import "RRPageViewController.h"
#import "RRContentViewController.h"

@interface RRSubViewViewController () <RRPageViewControllerDataSource, RRPageViewControllerDelegate>

// The pageController
@property (nonatomic, retain) RRPageViewController *pageController;

// View where we place the pageController in
@property (nonatomic, retain) IBOutlet UIView *pageHolder;

@end

// Use this as the viewPager dataSource
@implementation RRSubViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Create the pagecontroller
    self.pageController = [RRPageViewController new];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    // Add it to the pageHolder view as subview
    self.pageController.view.frame = self.pageHolder.bounds;
    [self.pageHolder addSubview:self.pageController.view];
    
    // Add some content controllers
    NSMutableArray <UIViewController *> *pages = [NSMutableArray new];
    for (int i = 0; i < 50; i++) {
        RRContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"content_controller"];
        vc.tag = i;
        [pages addObject:vc];
    }
    
    [self.pageController setPageControllers:pages];
    
    // Layout
    
    // Add some nice shadow to the holder view
    self.pageHolder.layer.shadowOffset = CGSizeZero;
    self.pageHolder.layer.shadowRadius = 5;
    self.pageHolder.layer.masksToBounds = NO;
    self.pageHolder.layer.shadowOpacity = .7;

}


@end
