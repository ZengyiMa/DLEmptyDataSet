//
//  UIScrollView+DLEmptyDataSet.h
//  Niupu_SNS
//
//  Created by famulei on 08/10/2016.
//  Copyright © 2016 WE. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


#pragma mark -  convenient view

// titleView
@interface DLEmptyDataSetTitleView : UIView
@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, strong) UILabel *titleLabel;
@end

// imageView
@interface DLEmptyDataSetImageView : DLEmptyDataSetTitleView
@property (nonatomic, assign) CGFloat titleAndImageSpace;
@property (nonatomic, strong) UIImageView *imageView;
@end



@protocol DLEmptyDataSetDelegate <NSObject>
@optional

/**
 返回空白视图的时候的要展示的文字标题

 @param scrollView 当前的 scrollView

 @return 返回富文本
 */
- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;

/**
 返回空白视图时候要展示的图片

 @param scrollView 当前的 scrollView

 @return 返回一个图片
 */
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView;

/**
 返回空白视图时候要展示的自定义视图(优先级最高，如果返回自定义视图将忽略其他展示)

 @param scrollView 当前的 scrollView

 @return 返回一个视图
 */
- (nullable UIView *)viewForEmptyDataSet:(UIScrollView *)scrollView;

/**
 返回空白展示控件距离顶部的偏移（默认是居中，也就是0，负数将往上移动，正数将往下移动， 对有效）

 @param scrollView 当前的 scrollView

 @return 返回指定偏移量
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView;

/**
 返回空白展示控件距离的距离（默认是10，只对图片的类型有效）

 @param scrollView 当前的 scrollView

 @return 返回指定的距离
 */
- (CGFloat)spaceOfImageAndTitleForEmptyDataSet:(UIScrollView *)scrollView;


/**
 是否对空白视图打开交互 (默认为 NO)

 @param scrollView 当前的 scrollView
 @return YES 为打开，NO 为关闭
 */
- (BOOL)enableUserInteractionForEmptyDataSet:(UIScrollView *)scrollView;

/**
 是否忽略 contentInset (默认为 YES)
 
 @param scrollView 当前的 scrollView
 @return YES 为打开，NO 为关闭
 */
- (BOOL)ignoreContentInsetForEmptyDataSet:(UIScrollView *)scrollView;

/**
 为空白视图设置颜色
 
 @param scrollView 当前的 scrollView
 @return 颜色
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView;


/**
 给空白视图添加 inset 距离 默认是 zero

 @param scrollView 当前的 scrollView
 @return inset
 */
- (UIEdgeInsets)edgeInsetsForEmptyDataSet:(UIScrollView *)scrollView;

@end



@interface UIScrollView (DLEmptyDataSet)

@property (nonatomic, weak) id<DLEmptyDataSetDelegate> dataSetDelegate;

- (void)reloadDataWithEmptyView;
- (void)reloadDataWithEmptyView:(BOOL)reloadData;


/**
 显示空白视图

 @param displayOrHidden 显示或者隐藏
 */
- (void)dl_displayEmptyView:(BOOL)displayOrHidden;
@end


NS_ASSUME_NONNULL_END

