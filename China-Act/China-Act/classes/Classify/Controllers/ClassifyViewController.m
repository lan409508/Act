//
//  ClassifyViewController.m
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "ClassifyViewController.h"
#import "RecommentModel.h"
#import "RecommentCollectionReusableView.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"

static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headerIdentifier = @"headerIdentifier";

@interface ClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) VOSegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray *mainArray;
@property (nonatomic, strong) NSMutableArray *gengxinArray;
@property (nonatomic, strong) NSMutableArray *tuijianArray;
@property (nonatomic, strong) NSMutableArray *shoucangArray;
@property (nonatomic, strong) NSMutableArray *zuixinArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    [self getListRequest];
    [self getRecommendedRequest];
    [self.view addSubview:self.segmentControl];
}



#pragma mark --------- CollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.gengxinArray.count;
    } else if (section == 1) {
        return self.tuijianArray.count;
    } else if (section == 2) {
        return self.shoucangArray.count;
    }
    return self.zuixinArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.mainArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    RecommentCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWidth, 10)];
    titlelabel.text = @"每周收藏";
    [headView addSubview:titlelabel];
    return headView;
    
}

#pragma mark -------- segmentControl

-(VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"推荐"},@{VOSegmentText:@"榜单"},@{VOSegmentText:@"类别"}]];
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.textColor = [UIColor lightGrayColor];
        self.segmentControl.selectedTextColor = [UIColor colorWithRed:254/255.0 green:149/255.0 blue:158/255.0 alpha:1.0];
        self.segmentControl.selectedIndicatorColor = [UIColor colorWithRed:254/255.0 green:149/255.0 blue:160/255.0 alpha:1.0];
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segmentControl.selectedBackgroundColor = self.segmentControl.backgroundColor;
//        self.segmentControl.selected = YES;
        self.segmentControl.allowNoSelection = NO;
        self.segmentControl.frame = CGRectMake(0, 30, kWidth, 40);
        self.segmentControl.selectedSegmentIndex = 0;
        self.segmentControl.indicatorThickness = 4;
        
        [self.view addSubview:self.segmentControl];
        [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
//             LXJLog(@"1: block --> %@", @(index));
        }];
        [self.segmentControl addTarget:self action:@selector(segmentContrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (void)segmentContrlValuechange:(VOSegmentedControl *)segment{
    self.classifyListType = segment.selectedSegmentIndex - 1;
    [self chooseResquest];
}

- (void)chooseResquest{
    switch (self.classifyListType) {
        case ClassifyListTypeRecommended:
            [self getRecommendedRequest];
            break;
        case ClassifyListTypeList:
            [self getListRequest];
            break;
        case ClassifyListTypeCategory:
            [self getCategoryRequest];
            break;
        default:
            break;
    }
}

#pragma mark --------- Custom Method

- (void)getRecommendedRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kGengxin parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                RecommentModel *model = [[RecommentModel alloc]initWithDictionary:dict];
                [self.gengxinArray addObject:model];
            }
        }
        
        

        [self loadTuijian];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadTuijian{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kTuijian parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                RecommentModel *model = [[RecommentModel alloc]initWithDictionary:dict];
                [self.tuijianArray addObject:model];
            }
        }
        [self loadShoucang];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadShoucang{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:KShoucang parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            if (self.shoucangArray.count > 0) {
                [self.shoucangArray removeAllObjects];
            }
            for (NSDictionary *dict in dataArray) {
                RecommentModel *model = [[RecommentModel alloc]initWithDictionary:dict];
                [self.shoucangArray addObject:model];
            }
        }
        [self.collectionView reloadData];

        [self loadZuixin];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadZuixin{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kZuixin parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *error = dic[@"error"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                RecommentModel *model = [[RecommentModel alloc]initWithDictionary:dict];
                [self.zuixinArray addObject:model];
            }
        }
        [self loadData];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)loadData{
    [self.mainArray addObject:self.gengxinArray];
    [self.mainArray addObject:self.tuijianArray];
    [self.mainArray addObject:self.shoucangArray];
    [self.mainArray addObject:self.zuixinArray];
    [self.view addSubview:self.collectionView];
}

- (void)getListRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getCategoryRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kCategory parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

# pragma mark --------- lazy loading

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        //设置每一行的间距
        layout.minimumLineSpacing = 3;
        //设置item的间距
        layout.minimumInteritemSpacing = 1;
        //设置区头区尾的大小
        layout.headerReferenceSize = CGSizeMake(kWidth, 30);
        //设置每个item的大小
        layout.itemSize = CGSizeMake(kWidth / 3 - 3, kHeight / 4);
        
        //通过一个layout布局来创建CollectionView
        self.collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, kWidth, kHeight - 130) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //注册item类型
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        //注册头部
        [self.collectionView registerNib:[UINib nibWithNibName:@"RecommentCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)mainArray{
    if (_mainArray == nil) {
        self.mainArray = [NSMutableArray new];
    }
    return _mainArray;
}

- (NSMutableArray *)gengxinArray{
    if (_gengxinArray == nil) {
        self.gengxinArray = [NSMutableArray new];
    }
    return _gengxinArray;
}

- (NSMutableArray *)tuijianArray{
    if (_tuijianArray == nil) {
        self.tuijianArray = [NSMutableArray new];
    }
    return _tuijianArray;
}

- (NSMutableArray *)shoucangArray{
    if (_shoucangArray == nil) {
        self.shoucangArray = [NSMutableArray new];
    }
    return _shoucangArray;
}

- (NSMutableArray *)zuixinArray{
    if (_zuixinArray == nil) {
        self.zuixinArray = [NSMutableArray new];
    }
    return _zuixinArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
