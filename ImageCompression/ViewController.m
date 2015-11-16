//
//  ViewController.m
//  ImageCompression
//
//  Created by ShikshaPC-41 on 03/10/15.
//  Copyright (c) 2015 AnshTech. All rights reserved.
//

#import "ViewController.h"
#import "URLClass.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
    UIImagePickerController *imagePickerController;
}

@property (weak, nonatomic) IBOutlet UIImageView *browseImgView;
@property (weak, nonatomic) IBOutlet UIImageView *compressedImgView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *mainImgLabel;
@property (weak, nonatomic) IBOutlet UILabel *compressedImgLabel;

@end

@implementation ViewController



- (void)viewDidLoad {
    [self hideView];
    [super viewDidLoad];
//    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    imgV.image = [UIImage imageNamed:@"background.png"];
//    [self.view addSubview:imgV];
    
      UIBarButtonItem *send = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(sendBtnClicked)];
//    UIBarButtonItem *send = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnClicked)];
    UIBarButtonItem *browse = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(browseBtnClicked)];
//    UIBarButtonItem *browse = [[UIBarButtonItem alloc]initWithTitle:@"Browse" style:UIBarButtonItemStylePlain target:self action:@selector(browseBtnClicked)];
    
    UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraBtnClicked)];
//     UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(cameraBtnClicked)];
    
    UIBarButtonItem *clean = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(cleanBtnClicked)];
    //     UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(cameraBtnClicked)];
    
    self.navigationItem.rightBarButtonItems = @[send,browse,camera,clean];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideView{
    [self.browseImgView setHidden:YES];
    [self.compressedImgView setHidden:YES];
    
    [self.mainImgLabel setHidden:YES];
    [self.compressedImgLabel setHidden:YES];
}

-(void)cleanBtnClicked{
    [self.browseImgView setImage:nil];
    [self.compressedImgView setImage:nil];
    [self.mainImgLabel setText:@""];
    [self.compressedImgLabel setText:@""];
}

-(void)cameraBtnClicked{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate =self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)browseBtnClicked{
    
    [self.browseImgView setHidden:NO];
    [self.mainImgLabel setHidden:NO];
    [self.compressedImgLabel setHidden:YES];
    [self.compressedImgView setHidden:YES];
    
    
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate =self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.browseImgView setHidden:NO];

    self.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.browseImgView.image = self.image;
    NSData *data = [[NSData alloc]initWithData:UIImagePNGRepresentation(self.image)];
    self.mainImgLabel.text = [self getImageSize:data];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)sendBtnClicked{
    if(self.browseImgView.image){
        [self.compressedImgView setHidden:NO];
        [self.compressedImgLabel setHidden:NO];
        UIImage * imageToSend = [self compressImage:self.image];
        NSData *imagesize = [[NSData alloc]initWithData:UIImagePNGRepresentation(imageToSend)];
        [self sendDataToServer:imagesize];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Pick some image" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//- (void)sendBtn{
//    [self.compressedImgView setHidden:NO];
//    [self.compressedImgLabel setHidden:NO];
//    UIImage * imageToSend = [self compressImage:self.image];
//    NSData *imagesize = [[NSData alloc]initWithData:UIImagePNGRepresentation(imageToSend)];
//    [self sendDataToServer:imagesize];
//}

-(void)sendDataToServer:(NSData *)data{
//    IMAGE to DATA to BASE_64_String
    NSString *urlString = uploadImage;

    self.compressedImgLabel.text = [self getImageSize:data];
    self.compressedImgView.image = [UIImage imageWithData:data];
    NSString *name = @"mypics";

    if (data != nil)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [[NSMutableData alloc]init];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"%@.png\"\r\n\r\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:data]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
// SETTING BODY to REQUEST
        [request setHTTPBody:body];
// MAkE WEB CONNECTION
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Returning String\n\n %@\n\n",returnString);
    }
}

#pragma mark - Compress Image

-(UIImage *)compressImage: (UIImage *)image{
    CGSize originalSize = image.size;
    CGFloat scale = 0.3f;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
// Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *data = [[NSData alloc]initWithData:UIImagePNGRepresentation(compressedImage)];
     float size = data.length;
    if(size <10240){
        return compressedImage;
    }

    else{
        return [self compressImage:compressedImage];
    }
}

#pragma mark - GET IMAGE SIZE

-(NSString *)getImageSize:(NSData *)image{
    float size = 0.0f;
    NSString *string;
//    NSData *data = [[NSData alloc]initWithData:UIImagePNGRepresentation(self.image)];
    size = image.length;
    if (size < 1024 ) {
        string = [NSString stringWithFormat:@"%.2fbytes",size];
    }
    else if (1024 < size && size <1048576){
        string = [NSString stringWithFormat:@"%.2fkb",size/1024];
    }
    else if (size > 1048576){
        string = [NSString stringWithFormat:@"%.2fmb",size/(1024*1024)];
    }
    return string;
}

-(float)getImageSizeInFloat:(NSData *)imageData{
    float size = 0.0f;
    size = imageData.length;
    return size;
}

@end
