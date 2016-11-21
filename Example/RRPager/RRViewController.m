//
//  RRViewController.m
//  RRPager
//
//  Created by Rutger Nijhuis on 11/21/2016.
//  Copyright (c) 2016 Rutger Nijhuis. All rights reserved.
//

#import "RRViewController.h"
#import "RRContentViewController.h"

@interface RRViewController ()

@end

@implementation RRViewController{
 
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSMutableArray <UIViewController *> *pages = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        RRContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"content_controller"];
        vc.tag = i;
        vc.view.backgroundColor = i % 2 ? [UIColor redColor] : [UIColor greenColor];
        [pages addObject:vc];
    }
    
    [self setPageControllers:pages];
    
    // Test reload after 2 sec
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testReload];
    });
}


#pragma mark - Testing

- (void)scrollTest{
    [self scrollToIndex:4 animated:YES];
}

- (void)testReload{
    // Test reload with other controllers
    NSMutableArray <UIViewController *> *pages = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        RRContentViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"content_controller"];
        vc.tag = i;
        [pages addObject:vc];
    }
    
    // Refresh pages
    [self setPageControllers:pages];
    
    // Instant scroll to index 5
    [self scrollToIndex:5 animated:NO];
}



@end
