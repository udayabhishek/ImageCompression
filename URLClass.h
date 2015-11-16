//
//  URLClass.h
//  ImageCompression
//
//  Created by ShikshaPC-41 on 05/10/15.
//  Copyright (c) 2015 AnshTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLClass : NSObject

#define URL @"http://192.168.0.8:9009/ImgCompression/"

#define uploadImage URL @"uploadImage.php"
#define getImage URL @"getImage.php"
#define getImageDirectory URL @"uploadedImages/"
@end
