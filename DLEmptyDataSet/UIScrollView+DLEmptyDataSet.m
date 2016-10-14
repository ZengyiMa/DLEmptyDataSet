//
//  UIScrollView+DLEmptyDataSet.m
//  Niupu_SNS
//
//  Created by famulei on 08/10/2016.
//  Copyright © 2016 WE. All rights reserved.
//

#import "UIScrollView+DLEmptyDataSet.h"
#import <objc/runtime.h>

static char kDLEmptyViewKey;
static char kDLEmptyDelegateKey;



// weak proxy
@interface DLEmptyDataSetWeakObject : NSObject
@property (nonatomic, weak) id weakObject;
- (instancetype)initWithObject:(id)object;
@end


@implementation DLEmptyDataSetWeakObject
- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        self.weakObject = object;
    }
    return self;
}
@end



// helper view
@implementation DLEmptyDataSetTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    CGSize textSize =  [self.titleLabel.attributedText boundingRectWithSize:self.frame.size options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) context:nil].size;
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, ceil(textSize.height));
    CGRect titleLabelRect = self.titleLabel.frame;
    titleLabelRect.origin.y = self.frame.size.height / 2;
    titleLabelRect.origin.y += self.verticalOffset;
    self.titleLabel.frame = titleLabelRect;
    
}

@end


@implementation DLEmptyDataSetImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = self.imageView.image.size;
    CGSize textSize =  [self.titleLabel.attributedText boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat conetentHeight =  (imageSize.height + textSize.height + self.titleAndImageSpace);
    CGFloat centerY = self.frame.size.height / 2 - conetentHeight / 2;
    centerY += self.verticalOffset;
    CGRect imageRect = CGRectZero;
    imageRect.size = imageSize;
    imageRect.origin.y = centerY;
    imageRect.size.width = self.frame.size.width;
    
    self.imageView.frame = imageRect;
    self.titleLabel.frame = CGRectMake(0, self.imageView.frame.origin.y + imageSize.height + self.titleAndImageSpace, self.frame.size.width, textSize.height);
}


@end






@implementation UIScrollView (DLEmptyDataSet)


- (UIView *)dl_emptyView
{
    return objc_getAssociatedObject(self, &kDLEmptyViewKey);
}

- (void)dl_setEmptyView:(UIView *)view
{
    objc_setAssociatedObject(self, &kDLEmptyViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setDataSetDelegate:(id<DLEmptyDataSetDelegate>)emptyDataSetDelegate
{
    
    DLEmptyDataSetWeakObject *weakObject = [[DLEmptyDataSetWeakObject alloc]initWithObject:emptyDataSetDelegate];
    objc_setAssociatedObject(self, &kDLEmptyDelegateKey, weakObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<DLEmptyDataSetDelegate>)dataSetDelegate
{
    DLEmptyDataSetWeakObject *weakObject = objc_getAssociatedObject(self, &kDLEmptyDelegateKey);
    return weakObject.weakObject;
}


- (void)reloadDataWithEmptyView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isKindOfClass:[UITableView class]]) {
            [((UITableView *)self) reloadData];
            if ([self dataSetIsEmptyWithTableView:(UITableView *)self]) {
                // 数据源为空
                [self dl_displayEmptyView:YES];
            }
            else
            {
                [self dl_displayEmptyView:NO];
            }
        }
    });
}









- (void)dl_displayEmptyView:(BOOL)display
{
    if (display) {
        
        UIView *emptyView = nil;
        if ([self.dataSetDelegate respondsToSelector:@selector(viewForEmptyDataSet:)]) {
            // custom view
            emptyView = [self.dataSetDelegate viewForEmptyDataSet:self];
        }
        else
        {
            // title
            NSAttributedString *title = [self.dataSetDelegate respondsToSelector:@selector(titleForEmptyDataSet:)] ?
                                        [self.dataSetDelegate titleForEmptyDataSet:self] : nil;
            
            // image
            UIImage *image = [self.dataSetDelegate respondsToSelector:@selector(imageForEmptyDataSet:)] ?
                             [self.dataSetDelegate imageForEmptyDataSet:self] : nil;
            
            
            CGFloat verticalOffset = [self.dataSetDelegate respondsToSelector:@selector(verticalOffsetForEmptyDataSet:)] ?
                                     [self.dataSetDelegate verticalOffsetForEmptyDataSet:self] : 0;
            
            CGFloat imageAndTitleSpace = [self.dataSetDelegate respondsToSelector:@selector(spaceOfImageAndTitleForEmptyDataSet:)] ?
                                            [self.dataSetDelegate spaceOfImageAndTitleForEmptyDataSet:self] : 10;

            
            if (image) {
                // image
               DLEmptyDataSetImageView *imageStyleView = [DLEmptyDataSetImageView new];
                imageStyleView.verticalOffset = verticalOffset;
                imageStyleView.titleAndImageSpace = imageAndTitleSpace;
                imageStyleView.imageView.image = image;
                if (title) {
                    imageStyleView.titleLabel.attributedText = title;
                }
                emptyView = imageStyleView;

            }
            else if (title)
            {
                DLEmptyDataSetTitleView *titleStyleView = [DLEmptyDataSetTitleView new];
                titleStyleView.verticalOffset = verticalOffset;
                titleStyleView.titleLabel.attributedText = title;
                emptyView = titleStyleView;
            }
        }
        
        
        
        [[self dl_emptyView] removeFromSuperview];
        [self dl_setEmptyView:emptyView];
        if (emptyView) {
            emptyView.hidden = NO;
            emptyView.frame = CGRectMake(0, self.bounds.origin.y, self.frame.size.width, self.frame.size.height);
            if (emptyView.superview) {
                [self bringSubviewToFront:emptyView];
            }
            else
            {
                [self addSubview:emptyView];
            }
        }
    }
    else
    {
        [self dl_emptyView].hidden = YES;
    }
}



- (BOOL)dataSetIsEmptyWithTableView:(UITableView *)tableView
{
    id<UITableViewDataSource> dataSource = tableView.dataSource;
    BOOL isEmpty = YES;
    NSUInteger section = [dataSource numberOfSectionsInTableView:(UITableView *)self];
    if (section == 0) {
        isEmpty = YES;
    }
    
    for (NSUInteger i = 0; i < section; ++i) {
        NSUInteger row = [dataSource tableView:(UITableView *)self numberOfRowsInSection:i];
        if (row != 0) {
            // 不等于0 说明有数据。
            isEmpty = NO;
            break;
        }
    }
    return isEmpty;
}


@end
