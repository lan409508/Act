//
//  BuyViewController.m
//  China-Act
//
//  Created by scjy on 16/3/4.
//  Copyright © 2016年 练晓俊. All rights reserved.
//

#import "BuyViewController.h"
#import "HeaderCollectionReusableView.h"
static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headerItemIdentifier = @"headeritemIdentifier";
static NSString *footerItemIdentifier = @"footeritemIdentifier";

@interface BuyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray  *heightArr;
//@property (strong, nonatomic) UICollectionView *collectionView;
//@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美图";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:150/255.0 blue:160/255.0 alpha:1.0]}];
}

- (void)loadView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init]
    ;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerItemIdentifier];
    
    [collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerItemIdentifier];
    self.view = collectionView;
    self.view.backgroundColor = [UIColor clearColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *myCell=[collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    NSInteger remainder=indexPath.row%3;
    NSInteger currentRow=indexPath.row/3;
    CGFloat   currentHeight=[self.heightArr[indexPath.row] floatValue];
    CGFloat positonX=100*remainder+10*(remainder+1);
    CGFloat positionY=(currentRow+1)*10;
    for (NSInteger i=0; i<currentRow; i++) {
        NSInteger position=remainder+i*3;
        positionY+=[self.heightArr[position] floatValue];
    }
    myCell.frame = CGRectMake(positonX, positionY,100,currentHeight) ;
//    NSUInteger randomNumber=arc4random_uniform(9);
//    NSString *girlFilename = [NSString stringWithFormat:@"Girl%lu.jpg", (unsigned long)randomNumber];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:girlFilename]];
//    
//    [myCell setBackgroundView:imageView];
    myCell.backgroundColor = [UIColor redColor];
    return  myCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=100+(arc4random()%160);
    [self.heightArr addObject:[NSString stringWithFormat:@"%f",height]];
    return  CGSizeMake(100, height);
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
