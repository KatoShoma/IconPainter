//
//  CxxImageProcessor.cpp
//  icon-painter
//
//  Created by ShomaKato on 2024/03/17.
//

#include "CxxImageProcessor.hpp"
#import "IconPainter-Swift.h"

#import <opencv2/opencv.hpp>

std::vector<uint8_t> CxxImageProcessor::findContourFromUIImage(std::string assetName, int image_width, int image_height) {
    std::vector<uint8_t> pixelValues;
    auto imageProcesser = IconPainter::ImageConverter::init(assetName);
    auto pixelValueArray = imageProcesser.getPixelValueFromUIImage();
    int channel = int(imageProcesser.getImageChannel());
    for (const auto &pixelValue: pixelValueArray) {
        pixelValues.push_back((uint8_t) pixelValue);
    }
    
    cv::Mat src_img = array_to_Mat(pixelValues, image_width, image_height, channel);
    cv::Mat origin_img, gray_img, bin_img, bin_inv_img;
    origin_img = src_img.clone();
    cv::cvtColor(src_img, gray_img, cv::COLOR_RGBA2GRAY);
    cv::threshold(gray_img, bin_img, 1, 255, cv::THRESH_BINARY);

    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(bin_img, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    for( size_t i = 0; i< contours.size(); i++ ) {
        cv::drawContours(origin_img, contours, i, cv::Scalar(0, 255, 0, 255), -1);
    }

    std::vector<uint8_t> outputPixelValues = Mat_to_array(origin_img);

    return outputPixelValues;
}

cv::Mat CxxImageProcessor::array_to_Mat(std::vector<uint8_t> array, int width, int height, int channel) {
    cv::Mat image;
    if (channel == 4) {
        image = cv::Mat(height, width, CV_8UC4, array.data());
        cv::cvtColor(image, image, cv::COLOR_BGRA2RGBA); // RGBAの並びに変更
    }
    return image;
}

std::vector<uint8_t> CxxImageProcessor::Mat_to_array(cv::Mat image) {
    std::vector<uint8_t> array;
    array.assign(image.data, image.data + image.total() * image.elemSize());
    return array;
}

CxxImageProcessor::CxxImageProcessor() {}
