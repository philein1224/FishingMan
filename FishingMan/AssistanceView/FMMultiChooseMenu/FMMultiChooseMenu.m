//
//  FMMultiChooseMenu.m
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMMultiChooseMenu.h"
#import "FMMultiChooseCell.h"

#define ZXHScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ZXHScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface FMMultiChooseMenu ()
{
    NSArray *dataArray;
    double ContentYOffset;
    NSMutableArray * multipleSelectedRows;
}

@property (weak, nonatomic) IBOutlet UIView *alphaBGView;
@property (weak, nonatomic) IBOutlet UIView *activeContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeContainerHeight;

@end

@implementation FMMultiChooseMenu

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.alphaBGView addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.alphaBGView addGestureRecognizer:pan];
}

+ (instancetype)shareWithTarget:(id)target
                          array:(NSArray *)array
                       callback:(FMMultiChooseMenuCallback) callback{
    
    FMMultiChooseMenu *chooseMenu = [[[NSBundle mainBundle] loadNibNamed:@"FMMultiChooseMenu" owner:self options:nil] firstObject];
    
    chooseMenu->dataArray = [[NSArray alloc] initWithArray:array];
    
    if((45 + 45 * array.count) >= ZXHScreenHeight){
        chooseMenu->ContentYOffset = ZXHScreenHeight - 20;
        CLog(@"chooseMenu %lu, %f", 45 + 45 * array.count, ZXHScreenHeight);
    }
    else{
        CLog(@"chooseMenu %lu, %f", 45 + 45 * array.count, ZXHScreenHeight);
        chooseMenu->ContentYOffset = 45 + 45 * array.count;
    }
    
    chooseMenu->multipleSelectedRows = [[NSMutableArray alloc] init];
    
    chooseMenu.callback = callback;
    
    chooseMenu.alphaBGView.alpha = 0.0;
    chooseMenu.activeContainerView.frame = CGRectMake(0,
                                                      ZXHScreenHeight,
                                                      ZXHScreenWidth,
                                                      chooseMenu->ContentYOffset);
    chooseMenu.frame = CGRectMake(0,
                                  0,
                                  ZXHScreenWidth,
                                  ZXHScreenHeight);
    
    chooseMenu.tableView.allowsMultipleSelection = YES;
    [chooseMenu.tableView registerNib:[UINib nibWithNibName:@"FMMultiChooseCell" bundle:nil]forCellReuseIdentifier:@"FMMultiChooseCell"];
    
    /*** 背景高斯模糊 ***/
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
//    [commentView.bgImageView addSubview:effectView];
    
    NSLog(@"activeContainerHeight %f", chooseMenu.activeContainerHeight.constant);
    
    chooseMenu.activeContainerHeight.constant = chooseMenu->ContentYOffset;
    
    return chooseMenu;
}

- (void)show{
   
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.frame = CGRectMake(0, 0, ZXHScreenWidth, ZXHScreenHeight);
    self.alphaBGView.alpha = 0.0;
    
    self.activeContainerView.frame = CGRectMake(0,
                                                ZXHScreenHeight,
                                                ZXHScreenWidth,
                                                ContentYOffset);
    
    [UIView animateWithDuration:0.5 animations:^{
    
        self.activeContainerView.frame = CGRectMake(0,
                                                    ZXHScreenHeight - ContentYOffset,
                                                    ZXHScreenWidth,
                                                    ContentYOffset);
        
        self.alphaBGView.alpha = 0.4;
        
    } completion:^(BOOL finished) {
        
        [self.tableView reloadData];
    }];
}

- (void)dismiss{
    
    self.alphaBGView.alpha = 0.4;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.activeContainerView.frame = CGRectMake(0,
                                                    ZXHScreenHeight,
                                                    ZXHScreenWidth,
                                                    ContentYOffset);
        
        self.alphaBGView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismiss];
}
- (IBAction)confirmButtonAction:(id)sender {
    
    if(multipleSelectedRows.count == 0){
        
        return;
    }
    
    //回调
    if(self.callback){
        
        self.callback(multipleSelectedRows);
    }
    
    [self dismiss];
}

#pragma mark tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"FMMultiChooseCell";
    
    FMMultiChooseCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FMMultiChooseCell" owner:self options:nil] firstObject];
    }
    cell.cellContentLabel.text = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    return UITableViewCellEditingStyleDelete & UITableViewCellEditingStyleInsert;
}

- (void)dealWithChoosedRow:(NSInteger)row isSelected:(BOOL)isSelected {
    
    if (isSelected) {
        
        [multipleSelectedRows addObject:[dataArray objectAtIndex:row]];
    }
    else{
        
        [multipleSelectedRows removeObject:[dataArray objectAtIndex:row]];
    }
    
    //选中一项立马刷新
//    self.callback(multipleSelectedRows);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    
    [self dealWithChoosedRow:indexPath.row isSelected:cell.selected];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    [self dealWithChoosedRow:indexPath.row isSelected:cell.selected];
}

@end
