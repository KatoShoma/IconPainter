//
//  CxxImageProcessor.hpp
//  icon-painter
//
//  Created by ShomaKato on 2024/03/17.
//

#ifndef CxxImageProcessor_hpp
#define CxxImageProcessor_hpp

#include <stdio.h>
#include <iostream>
#import <opencv2/opencv.hpp>

class CxxImageProcessor {
public:
    CxxImageProcessor();

    std::vector<uint8_t> process(std::string assetName, int image_width, int image_height);
private:
    cv::Mat array_to_Mat(std::vector<uint8_t> array, int width, int height, int channel);

    std::vector<uint8_t> Mat_to_array(cv::Mat image);
};

#endif /* CxxImageProcessor_hpp */
