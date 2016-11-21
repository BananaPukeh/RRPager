//
//  RRPageViewController.h
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import <UIKit/UIKit.h>

@class RRPageViewController;

@protocol RRPageViewControllerDataSource <NSObject>

@required

- (NSUInteger)pageControllerNumberOfPages:(RRPageViewController *)controller;

- (UIViewController *)pageController:(RRPageViewController *)controller pageForIndex:(NSInteger)index;

@end


@interface RRPageViewController : UIViewController


/**
 Our paging datasource supplier
 */
@property (nonatomic, assign) id <RRPageViewControllerDataSource> dataSource;

@end
