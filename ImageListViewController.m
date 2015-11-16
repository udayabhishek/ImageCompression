//
//  ImageListViewController.m
//  ImageCompression
//
//  Created by ShikshaPC-41 on 06/10/15.
//  Copyright (c) 2015 AnshTech. All rights reserved.
//

#import "ImageListViewController.h"
#import "URLClass.h"
#import "ImageTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
@interface ImageListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *imgArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *sendCompressedImgBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendCompressedImageBtnClicked)];
    self.navigationItem.rightBarButtonItem = sendCompressedImgBtn;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendCompressedImageBtnClicked{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadImage];
    [self.tableView reloadData];
}


-(void)loadImage{
    NSString *str = getImage;
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(data!=nil){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(array!= (id)[NSNull null]){
        self.imgArray = [array mutableCopy];
        }
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgArray.count;
}

-(UIImage *)getImageFromURL:(NSString *)imageString{
    NSString *strURL = [NSString stringWithFormat:@"%@%@",getImageDirectory,imageString];
    NSURL *url = [NSURL URLWithString:strURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    ImageTableViewCell *cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = (ImageTableViewCell *)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIImage *img = [self getImageFromURL:[self.imgArray objectAtIndex:indexPath.row]];
    
    cell.imageInCell.image = img;
//    cell.imageInCell.layer.shouldRasterize = YES;
    cell.imageInCell.layer.masksToBounds = YES;
    
    [cell.imageInCell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    cell.imageInCell.layer.borderWidth = 1.0f;
    cell.imageInCell.layer.cornerRadius = 10.0f;
    
//    Shadow Effet for Cell
//    [cell.imageInCell.layer setShadowColor:[UIColor redColor].CGColor];
//    [cell.imageInCell.layer setShadowOpacity:0.8];
//    [cell.imageInCell.layer setShadowRadius:3.0];
//    [cell.imageInCell.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    return cell;
}

@end
