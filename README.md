# DLEmptyDataSet 
## 背景
有一个第三方库[DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)做的很棒，但是由于使用 AutoLayout 的布局，使用 2 个 UITableView 在同一个界面的的时候会出现不对齐的 Bug，并且没有好的方案来解决，于是重新写了一个这个东西，目前在项目中使用良好。

## 介绍
DLEmptyDataSet 是一款在能在 UITableView 或者 UICollectionView  数据为空的时候显示一张占位图的小工具。效果类似[DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)

## 安装
CocoaPods

```
pod 'DLEmptyDataSet'
```

手动：

```
把文件直接拖到项目中即可
```

## 基本使用
1. 设置 UITableView 的 dataSetDelegate 属性。
2. 按需实现 DLEmptyDataSetDelegate 协议方法。
3. 使用 TableView 的 reloadDataWithEmptyView 方法来刷新一个 TableView。

## 说明（协议方法）
```
titleForEmptyDataSet
```
返回空白视图的时候的要展示的文字标题。

```
imageForEmptyDataSet
```
返回空白视图时候要展示的图片

```
viewForEmptyDataSet
```
返回空白视图时候要展示的自定义视图(优先级最高，如果返回自定义视图将忽略其他展示)

```
verticalOffsetForEmptyDataSet
```
返回空白展示控件距离顶部的偏移（默认是居中，也就是0，负数将往上移动，正数将往下移动， 对有效）

```
spaceOfImageAndTitleForEmptyDataSet
```
返回空白展示控件距离的距离（默认是10，只对图片的类型有效）

```
enableUserInteractionForEmptyDataSet
```
是否对空白视图打开交互 (默认为 NO)

```
ignoreContentInsetForEmptyDataSet
```
是否忽略 contentInset (默认为 YES)











