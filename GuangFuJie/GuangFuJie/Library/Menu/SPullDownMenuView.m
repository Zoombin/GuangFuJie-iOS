//
//  SPullDownMenuView.m
//  meidianjie
//
//  Created by HYS on 16/3/4.
//  Copyright © 2016年 HYS. All rights reserved.
//

#import "SPullDownMenuView.h"
#import "SMenuButton.h"
#import "SMenuCell.h"

@interface SPullDownMenuView()<UITableViewDataSource, UITableViewDelegate>{
    UIColor *_menuColor;
    NSInteger _numOfMenu;
    //当前选择的btn
    NSInteger _selectBtnIndex;
    //selecttitle的index
    NSInteger _currentTitleIndex;
    //select = yes的button
    NSInteger _currentIndex;
    UIView *_backgroundView;
    BOOL _show;
}
/**
 *  存放button
 */
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
/**
 *  存放title
 */
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SPullDownMenuView

- (NSMutableArray *)titleBtnArray{
    if(!_titleBtnArray){
        _titleBtnArray = [NSMutableArray new];
    }
    return _titleBtnArray;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titleArray withImages:(NSArray *)images withSelectColor:(UIColor *)color{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MColor(230, 230, 230);
        _titleArray = [NSArray arrayWithArray:titleArray];
        _images = [NSArray arrayWithArray:images];
        BOOL showTitles = images.count == 0;
        _menuColor = MColor(110, 110, 110);
        _numOfMenu = titleArray.count;
        CGFloat btnW = SScreen_Width / _numOfMenu * 1.0;
        for (int i = 0; i < _numOfMenu; i++) {
            SMenuButton *btn = [[SMenuButton alloc]initWithFrame:CGRectMake(i * btnW, 0, btnW - 1, self.frame.size.height)];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:color forState:UIControlStateSelected];
            if ([[_titleArray objectAtIndex:i] count] > 1) {
                [btn setImage:[UIImage imageNamed:@"selectdown"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"selectdown1"] forState:UIControlStateSelected];
            }
            
            btn.titleLabel.font = MFont(16);
            [btn setTitleColor:_menuColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
            if (showTitles) {
                [btn setTitle:[[titleArray objectAtIndex:i] objectAtIndex:0] forState:UIControlStateNormal];
            } else {
                [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            }
            if (i == 0) {
                btn.selected = YES;
            }
            [self addSubview:btn];
            
            UIButton *unSelectedMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            unSelectedMarkButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - frame.size.height, 0, frame.size.height, frame.size.height);
            [unSelectedMarkButton setImage:[UIImage imageNamed:@"menu_unselected_gray"] forState:UIControlStateNormal];
            unSelectedMarkButton.userInteractionEnabled = NO;
            [btn addSubview:unSelectedMarkButton];
            
            [self.titleBtnArray addObject:btn];
        }
        _currentIndex = 0;
        _currentTitleIndex = 0;
        _show = NO;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.origin.y, SScreen_Width, 0) style:UITableViewStylePlain];
        _tableView.tintColor = color;
        _tableView.rowHeight = 36;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [_backgroundView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)selectMenu:(SMenuButton *)sender{
    NSInteger selectIndex = [self.titleBtnArray indexOfObject:sender];
    if (_show) {
        if (selectIndex != _currentIndex ) {
            if (_selectBtnIndex == selectIndex) {
                [self dismissAnimationWithTableViewWithBtn:sender];
                return;
            }else{
                [self dismissAnimationWithTableViewWithBtn:_titleBtnArray[_currentIndex]];
            }
        }else{
            if (_selectBtnIndex != selectIndex) {
                [self dismissAnimationWithTableViewWithBtn:_titleBtnArray[_selectBtnIndex]];
            }else{
                [self dismissAnimationWithTableViewWithBtn:sender];
                return;
            }
        }
    }
    _selectBtnIndex = selectIndex;
    NSArray *array = _titleArray[_selectBtnIndex];
    
    if (array.count <= 1) {
        SMenuButton *btn = [self.titleBtnArray objectAtIndex:_currentIndex];
        btn.selected = NO;
        sender.selected = YES;
        _currentIndex = _selectBtnIndex;
        _currentTitleIndex = 0;
        _show = NO;
        [self.delegate pullDownMenuView:self didSelectedIndex:[NSIndexPath indexPathForRow:_currentIndex inSection:_currentTitleIndex]];
    }else{
        //弹出tableView
        _show = YES;
        [self animationWithTableViewWithBtn:sender];
    }
    
}

//弹出tableview动画
- (void)animationWithTableViewWithBtn:(SMenuButton *)sender{
    sender.hidden = YES;
    
    _tableView.frame = CGRectMake(0, 0, SScreen_Width, 0);
    _backgroundView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), SScreen_Width, SScreen_Height - CGRectGetMaxY(_tableView.frame));
    [_tableView reloadData];
    [self.superview addSubview:_backgroundView];
    [self.superview addSubview:_tableView];
    CGFloat tableViewH = [_tableView numberOfRowsInSection:0] * self.frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, tableViewH);
//        sender.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }];
}

//收回tableView动画
- (void)dismissAnimationWithTableViewWithBtn:(SMenuButton *)sender{
    sender.hidden = NO;
    
//    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
//        sender.imageView.layer.transform = CATransform3DIdentity;
//    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        _show = NO;
//    }];
}

//收回动画
- (void)tapClick{
    [self dismissAnimationWithTableViewWithBtn:[self.titleBtnArray objectAtIndex:_selectBtnIndex]];
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _titleArray[_selectBtnIndex];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *menuCell = @"menuCell";
    SMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCell];
    if (!cell) {
        cell = [[SMenuCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:menuCell];
        cell.textLabel.font = MFont(14);
    }
    [cell initView:self.frame];
    [cell setIsSelected:_currentTitleIndex == indexPath.row];
    [cell.imageButton setImage:[UIImage imageNamed:self.images[indexPath.row]] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMenuButton *btn1 = [self.titleBtnArray objectAtIndex:_selectBtnIndex];
    SMenuButton *btn2 = [self.titleBtnArray objectAtIndex:_currentIndex];
    if (_selectBtnIndex != _currentIndex) {
        btn1.selected = YES;
        btn2.selected = NO;
    }
    _currentIndex = _selectBtnIndex;
    _currentTitleIndex = indexPath.row;
    if (self.images.count > 0) {
        [btn1 setImage:[UIImage imageNamed:self.images[_currentTitleIndex]] forState:UIControlStateNormal];
    } else {
        [btn1 setTitle:[[_titleArray objectAtIndex:_currentIndex] objectAtIndex:_currentTitleIndex] forState:UIControlStateNormal];
    }
    [self.delegate pullDownMenuView:self didSelectedIndex:[NSIndexPath indexPathForRow:_currentIndex inSection:_currentTitleIndex]];
    [self dismissAnimationWithTableViewWithBtn:btn1];
}

@end
