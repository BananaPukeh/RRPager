//
//  RRPageControl.h
//  Pods
//
//  Created by Rutger Nijhuis on 21/11/2016.
//
//

#import <UIKit/UIKit.h>

@class RRPageControl;

@protocol RRPageControlDataSource <NSObject>

@required

- (NSUInteger)pageControlNumberOfTabs:(RRPageControl * _Nonnull)control;

- (nonnull UIView *)pageControl:(RRPageControl * _Nonnull)control viewForTabAtIndex:(NSUInteger)index;


@end


@protocol RRPageControlDelegate <NSObject>

@optional

- (void)pageControl:(RRPageControl * _Nonnull)control didSelectTabAtIndex:(NSUInteger)index;

@end


@interface RRPageControl : UIView

@property (nonnull, nonatomic, assign) id<RRPageControlDataSource> dataSource;
@property (nonnull, nonatomic, assign) id<RRPageControlDelegate> delegate;

/**
 Paging indicator
 */
@property (nonnull, nonatomic, retain, readonly) UIView *indicator;

@property (nonatomic, readonly) NSUInteger selectedIndex;

/**
 The width for the tabs
 Default: 50
 */
@property (nonatomic) NSUInteger tabWidth;


/**
 Reloads the dataSource
 */
- (void)reloadData;

/**
 Select a tab
 
 @param index The tabIndex to select
 */
- (void)selectTabAtIndex:(NSUInteger)index;

- (void)selectTabAtIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)scrollProgress:(CGFloat)progress;

@end
