//
//  ObjcImagePainter.m
//  icon-painter
//
//  Created by ShomaKato on 2024/03/17.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#include "ObjcImagePainter.h"

@implementation ObjcImagePainter

+(UIImage *)imagePainting: (UIImage *)image {
    cv::Mat source_img;
    UIImageToMat(image, source_img);

    cv::Mat painted_img, gray_img, bin_img;
    painted_img = source_img.clone();
    cv::cvtColor(source_img, gray_img, cv::COLOR_RGBA2GRAY);
    cv::threshold(gray_img, bin_img, 1, 255, cv::THRESH_BINARY);

    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(bin_img, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    for( size_t i = 0; i< contours.size(); i++ ) {
        cv::drawContours(painted_img, contours, i, cv::Scalar(0, 255, 0, 255), -1);
    }
    UIImage *dst_img = MatToUIImage(painted_img);
    return dst_img;
}

@end
