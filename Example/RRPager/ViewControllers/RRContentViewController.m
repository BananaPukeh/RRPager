//
//  RRContentViewController.m
//  RRPager
//
//  Created by Rutger Nijhuis on 21/11/2016.
//  Copyright © 2016 Rutger Nijhuis. All rights reserved.
//

#import "RRContentViewController.h"

@implementation RRContentViewController{
    IBOutlet UILabel *lblText;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    lblText.text = [NSString stringWithFormat:@"Page %lu", (long unsigned)self.tag];
}



@end
