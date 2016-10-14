//
//  ViewController.m
//  DLEmptyDataSetDemo
//
//  Created by famulei on 09/10/2016.
//  Copyright © 2016 famulei. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+DLEmptyDataSet.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, DLEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.dataSource = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    self.tableView.contentInset = UIEdgeInsetsMake(-200, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSetDelegate = self;
    [self.view addSubview:self.tableView];
    
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithTitle:@"增加" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(empty)];
    self.navigationItem.leftBarButtonItem = addItem;
    self.navigationItem.rightBarButtonItem = emptyItem;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    attr[NSParagraphStyleAttributeName] = paragraphStyle;

   return [[NSAttributedString alloc]initWithString:@"暂无数据" attributes:attr];
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"famuli_cry_zhubo"];
}


- (void)add
{
    [self.dataSource addObject:@""];
    [self.tableView reloadDataWithEmptyView];
}

- (void)empty
{
    [self.dataSource removeAllObjects];
    [self.tableView reloadDataWithEmptyView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"cell";
    return cell;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
