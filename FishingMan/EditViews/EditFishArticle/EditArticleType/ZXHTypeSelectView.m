//
//  ZXHTypeSelectView.m
//  ZiMaCaiHang
//
//  Created by maoqian on 16/8/17.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import "ZXHTypeSelectView.h"
#import "ZXHTypeSelectCell.h"

@interface ZXHTypeSelectView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) NSMutableArray * allTypeArray;

@end

@implementation ZXHTypeSelectView

- (void)dealloc{
    
    CLog(@"---[%@ dealloc]---", NSStringFromClass(self.class));
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.allTypeArray = [[NSMutableArray alloc] init];
    
    self.tableView.layer.cornerRadius = 2.0f;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.6f;
    
    self.imgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.imgView.layer.shadowRadius = 2.0f;
    self.imgView.layer.shadowOpacity = 0.6f;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectTypeCallback) {
        self.selectTypeCallback(indexPath.row, self.allTypeArray[indexPath.row]);
    }
    [self dismissView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _allTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"ZXHTypeSelectCell";
    
    ZXHTypeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZXHTypeSelectCell" owner:nil options:nil] firstObject];
    }
    
    cell.titleLbl.text = _allTypeArray[indexPath.row];
    cell.icon.image = ZXHImageName(cell.titleLbl.text);
    
    if (indexPath.row == self.currentIndex) {
        cell.titleLbl.textColor = ZXHColorHEX(@"36D8FF", 1);
    }
    else{
        cell.titleLbl.textColor = ZXHColorHEX(@"333333", 1);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark
#pragma mark - 弹出视图

+ (void)show:(NSMutableArray *)allTypeArray withSelected:(NSInteger)selectedType callback:(void(^)(NSInteger type, NSString * typeName))callback
{
    ZXHTypeSelectView *_typeSelectView =[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXHTypeSelectView class]) owner:self options:nil] lastObject];
    _typeSelectView.allTypeArray = allTypeArray;
    _typeSelectView.selectTypeCallback = callback;
    _typeSelectView.currentIndex = selectedType;
    
    _typeSelectView.frame = CGRectMake((ZXHScreenWidth - 140)/2, 53, 140,20+33*allTypeArray.count);
    
    // 显示视图
    [_typeSelectView showInView];
}
/**
 *  显示
 */
-(void) showInView
{
    if (_isDisplay) {
        return;
    }
    
    _isDisplay = YES;
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ZXHScreenWidth , ZXHScreenHeight)];
        
        self.backGroundView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        
        [self.backGroundView addGestureRecognizer:tapGesture];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:_backGroundView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/**
 *  隐藏
 */
-(void) dismissView
{
    _isDisplay = NO;
    self.alpha = 1;
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        
        [weakSelf.backGroundView removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

@end
