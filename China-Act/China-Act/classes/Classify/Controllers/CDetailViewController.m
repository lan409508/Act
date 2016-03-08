//
//  CDetailViewController.m
//  
//
//  Created by scjy on 16/3/8.
//
//

#import "CDetailViewController.h"
#import "UIViewController+Common.h"
#import "CDetailModel.h"
#import "CDetailCollectionReusableView.h"
#import <AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClassifyViewController.h"
#import "MessageViewController.h"

static NSString *itemIdentifier = @"itemIdentifier";

@interface CDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *BigArray;
@property (nonatomic, strong) NSString *name;

@end

@implementation CDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self showBackBtn];
    [self getModel];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.BigArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    CDetailModel *model = self.BigArray[indexPath.row];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.layout.itemSize.width, self.layout.itemSize.height - 30)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:nil];
    UILabel *updateInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, self.layout.itemSize.width, 20)];
    updateInfoLabel.text = model.updateInfo;
    updateInfoLabel.font = [UIFont systemFontOfSize:14.0];
    updateInfoLabel.textColor = [UIColor whiteColor];
    updateInfoLabel.textAlignment = NSTextAlignmentLeft;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, self.layout.itemSize.width, self.layout.itemSize.height)];
    titleLabel.text = model.name;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:imageV];
    [cell addSubview:titleLabel];
    [cell addSubview:updateInfoLabel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Classify" bundle:[NSBundle mainBundle]];                       MessageViewController *messageVC = [story instantiateViewControllerWithIdentifier:@"MessageVC"];
//    CDetailModel *model = self.BigArray[indexPath.row];
//    messageVC.messageId = model.Id;
//    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (void)getModel {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@&id=%@",kCDetail,self.CDetailID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *error = dic[@"error"];
        if ([error isEqualToString:@""] && code == 0) {
            NSArray *dataArray = dic[@"results"];
            for (NSDictionary *dict in dataArray) {
                CDetailModel *model = [[CDetailModel alloc] initWithDictionary:dict];
                [self.BigArray addObject:model];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumInteritemSpacing = 1;
        self.layout.minimumLineSpacing = 1;
        self.layout.headerReferenceSize = CGSizeMake(kWidth, 40);
        self.layout.footerReferenceSize = CGSizeMake(kWidth, 40);
        self.layout.itemSize = CGSizeMake(123, kHeight / 4);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)BigArray {
    if (_BigArray == nil) {
        self.BigArray = [NSMutableArray new];
    }
    return _BigArray;
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
