//
//  ImageProcessor.swift
//  IconPainter
//
//  Created by ShomaKato on 2024/03/14.
//

import UIKit
import opencv2

enum ImagePainter {
    static func imagePainting(assetName: String) -> UIImage? {
        guard let image = UIImage(named: assetName) else {
            return nil
        }
        let mat = Mat(uiImage: image)
        let matGray = mat.clone()

        // グレースケール化
        Imgproc.cvtColor(
            src: mat,
            dst: matGray,
            code: ColorConversionCodes.COLOR_RGBA2GRAY
        )

        // 二値化
        let matBinary = mat.clone()
        Imgproc.threshold(
            src: matGray,
            dst: matBinary,
            thresh: 100,
            maxval: 255,
            type: .THRESH_BINARY
        )

        // 領域抽出
        let contoursNSMutableArray: NSMutableArray = []
        let hierarchy = Mat()
        Imgproc.findContours(
            image: matBinary,
            contours: contoursNSMutableArray,
            hierarchy: hierarchy,
            mode: RetrievalModes.RETR_TREE,
            method: ContourApproximationModes.CHAIN_APPROX_SIMPLE
        )
        var contours: [[Point2i]] = []
        for contourObj in contoursNSMutableArray {
            if let contour = contourObj as? [Point2i] {
                if contour.count < 100 { // 面積閾値
                    continue
                }
                contours.append(contour)
            }
        }

        // 着色
        let greens: [Scalar] = [
            Scalar(0, 255, 0, 255),
            Scalar(0, 255, 0, 255),
            Scalar(0, 255, 0, 255)
        ]
        let colors: [Scalar] = [
            Scalar(0, 0, 255, 255),
            Scalar(255, 255, 0, 255),
            Scalar(255, 0, 0, 255)
        ]
        let coloringImage = mat.clone()
        for (index, contour) in contours.enumerated() {
            Imgproc.drawContours(
                image: coloringImage,
                contours: [contour],
                contourIdx: -1,
                color: colors[index],
                thickness: -1
            )
        }

        return coloringImage.toUIImage()
    }

    static func arrayToImage(pixelValues: [UInt8], width: Int, height: Int) -> UIImage? {
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        // ピクセルデータを使ってCGImageを生成
        guard let providerRef = CGDataProvider(data: Data(pixelValues) as CFData) else { return nil }
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bytesPerPixel * bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else { return nil }

        return UIImage(cgImage: cgim)
    }
}
