//
//  KGGWorkTimeChooseField.m
//  kuaigong
//
//  Created by Ding on 2017/10/24.
//  Copyright © 2017年 Ding. All rights reserved.
//

#import "KGGWorkTimeChooseField.h"

@interface KGGWorkTimeChooseField ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, copy)NSString *selectedText;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minutesArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *dayArray1;
//当前月份
@property (nonatomic, assign) int mouth;
//时间戳
@property (nonatomic, copy) NSString *timeString;
//月/天
@property (nonatomic, copy) NSString *mouthString;
@property (nonatomic, copy) NSString *mouthString1;

//时
@property (nonatomic, copy) NSString *hourString;

//分
@property (nonatomic, copy) NSString *minutesString;


//是否初始化
/**  */
@property (nonatomic,assign) BOOL  isInitial;

/**  */
@property (nonatomic,assign) NSUInteger  flag;

@end

@implementation KGGWorkTimeChooseField

- (void)initiaText
{
    if (_isInitial == NO) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
        _isInitial = YES;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.flag = 1;
        [self setup];
        [self addMonthDatasource];

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.flag = 1;
    [self setup];
     [self addMonthDatasource];
}

- (void)addMonthDatasource
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    _mouth = (int)[dateComponent month];
    int day = (int)[dateComponent day];
    int hour = (int)[dateComponent hour];
    KGGLog(@"month is: %d月", _mouth);
    KGGLog(@"day is: %d日", day);
    KGGLog(@"小时:%d",hour);
    int endDay = [[NSString getMonthBeginAndEndWith:[NSString stringWithFormat:@"%d",_mouth]] intValue];
//    KGGLog(@"%d",endDay);
    for (int i = hour; i < 24; i++) {
        NSString *hourString = [NSString stringWithFormat:@"%d时",i+1];
        [self.hourArray addObject:hourString];
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = day; i<endDay+1; i++) {
//            KGGLog(@"天是%d",i);
            NSString *dayString1 = [NSString stringWithFormat:@"%d月%d日",_mouth,i];
            [self.dayArray1 addObject:dayString1];
            if (i==day) {
                [self.dayArray addObject:@"今天"];
            }else if (i == day+1){
                [self.dayArray addObject:@"明天"];
            }else if (i == day+2){
                [self.dayArray addObject:@"后天"];
            }else{
                NSString *dayString = [NSString stringWithFormat:@"%d月%d日",_mouth,i];
                [self.dayArray addObject:dayString];
            }
        }
//    });
    
    //默认赋值
    self.mouthString1 = [self.dayArray1 firstObject];
    self.hourString =[self.hourArray firstObject];
    self.minutesString = [self.minutesArray firstObject];
}


//初始化
- (void)setup
{
    self.borderStyle = UITextBorderStyleNone;
    //创建pickerView
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView = pickerView;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    //自定义文本输入框
    self.inputView = pickerView;
    
    UIView *toolbar = [UIView new];
    toolbar.backgroundColor = UIColorHex(0xf8f9f9);
    toolbar.xc_height = KGGItemHeight;
    self.inputAccessoryView = toolbar;
    
    UIView *toplineView = [UIView new];
    toplineView.backgroundColor = KGGSeparatorColor;
    [toolbar addSubview:toplineView];
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(toolbar);
        make.height.mas_equalTo(KGGOnePixelHeight);
    }];
    
    UIView *bottomlineView = [UIView new];
    bottomlineView.backgroundColor = KGGSeparatorColor;
    [toolbar addSubview:bottomlineView];
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(toolbar);
        make.height.mas_equalTo(KGGOnePixelHeight);
    }];
    
    UIButton *ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureButton.titleLabel.font = KGGRegularFont(16);
    [ensureButton setTitle:@"确定" forState:UIControlStateNormal];
    [ensureButton addTarget:self action:@selector(ensureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [ensureButton setTitleColor:KGGGoldenThemeColor forState:UIControlStateNormal];
    [toolbar addSubview:ensureButton];
    [ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar);
        make.right.equalTo(toolbar).with.offset(-KGGRightPadding);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = KGGRegularFont(16);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:KGGTimeTextColor forState:UIControlStateNormal];
    [toolbar addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolbar);
        make.left.equalTo(toolbar).with.offset(KGGLeftPadding);
    }];
    
}

- (void)ensureButtonAction{
    self.text = self.selectedText;
    
//    KGGLog(@"选择日期%@",self.text);
    
    if ([self.workDelegate respondsToSelector:@selector(workTimeChooseFieldEnsureButtonClick)]) {
        [self.workDelegate workTimeChooseFieldEnsureButtonClick];
    }
    
    [self cancelButtonAction];
}

- (void)cancelButtonAction{
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder{
    [self initiaText];
    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark -UIPickerViewDelegate
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dayArray.count;
    }
    else if (component == 1){
        return self.hourArray.count;
    }else{
        return self.minutesArray.count;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        //设置第0列的标题信息
        _mouthString = [NSString stringWithFormat:@"%@",self.dayArray[row]];
        KGGLog(@"月份:%@",_mouthString);
        return _mouthString;
    }else if (component == 1){
        //设置第1列的标题信息
        _hourString = [NSString stringWithFormat:@"%@",self.hourArray[row]];
        return _hourString;
    }else{
        //设置第二列标题信息
        _minutesString = [NSString stringWithFormat:@"%@",self.minutesArray[row]];
        return _minutesString;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    KGGLog(@"component:%ld",(long)component);
    
    if (self.flag == 1) {
        _mouthString1 = [_dayArray1 firstObject];
    }
    
    if (component == 0) {
        self.flag++;
        [self setUpHours];
        _mouthString1 = self.dayArray1[row];
    }else if (component == 1){
        _hourString = self.hourArray[row];
    }else{
       _minutesString = _minutesArray[row];
    }
    KGGLog(@"月份%@天数%@时%@",self.mouthString,self.hourString,self.minutesString);
    self.selectedText = [NSString stringWithFormat:@"%@ %@%@",_mouthString1,_hourString,_minutesString];
}

#pragma mark - 获取当前月的天数
- (void)setUpHours
{
    KGGLog(@"self.flag:%lu",(unsigned long)self.flag);
    if (self.flag == 3 ) {
        [self.hourArray removeAllObjects];
        int endDay = [[NSString getMonthBeginAndEndWith:[NSString stringWithFormat:@"%d",self.mouth]] intValue];
        KGGLog(@"%d",endDay);
        for (int i = 0; i < 24; i++) {
            NSString *hourString = [NSString stringWithFormat:@"%d时",i+1];
            [self.hourArray addObject:hourString];
        }
        [self.pickerView reloadAllComponents];
    }
    
}


#pragma mark - 懒加载
- (NSMutableArray *)hourArray
{
    if (!_hourArray) {
        _hourArray = [NSMutableArray array];
    }
    return _hourArray;
}

- (NSMutableArray *)minutesArray
{
    if (!_minutesArray) {
        _minutesArray = [NSMutableArray arrayWithObjects:@"00分",@"10分",@"20分",@"30分",@"40分",@"50分", nil];
    }
    return _minutesArray;
}

- (NSMutableArray *)dayArray
{
    if (!_dayArray) {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

- (NSMutableArray *)dayArray1
{
    if (!_dayArray1) {
        _dayArray1 = [NSMutableArray array];
    }
    return _dayArray1;
}

- (void)dealloc
{
    KGGLogFunc
}


@end
