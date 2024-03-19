//
//  ImagePainterForCxx.swift
//  IconPainter
//
//  Created by ShomaKato on 2024/03/17.
//

import UIKit

public class ImagePainterForCxx {
    private let image: UIImage

    public init(assetName: std.string) {
        let assetNameString = String(assetName)
        self.image = UIImage(named: assetNameString)!
    }

    public func getImageChannel() -> Int {
        guard let cgImage = self.image.cgImage else {
            return 4
        }

        guard let colorSpace = cgImage.colorSpace else {
            return 4
        }

        let colorSpaceModel = colorSpace.model

        var channelCount: Int = 0
        switch colorSpaceModel {
        case .monochrome:
            channelCount = 1
        case .rgb:
            channelCount = 3
        default:
            break
        }

        if cgImage.alphaInfo != .none && cgImage.alphaInfo != .noneSkipLast && cgImage.alphaInfo != .noneSkipFirst {
            channelCount += 1
        }

        return channelCount
    }

    public func getPixelValueFromUIImage() -> [UInt8] {
        guard let cgImage = self.image.cgImage else { return [] }
        let width = cgImage.width
        let height = cgImage.height
        let colorSpaceModel = cgImage.colorSpace?.model

        var bytesPerPixel = 4
        var bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        var colorSpace = CGColorSpaceCreateDeviceRGB()

        switch colorSpaceModel {
        case .monochrome:
            bytesPerPixel = 1
            bitmapInfo = CGImageAlphaInfo.none.rawValue
            colorSpace = CGColorSpaceCreateDeviceGray()
        case .rgb:
            if cgImage.alphaInfo == .none {
                bytesPerPixel = 3
                bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
            }
        default:
            break
        }
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        // ビットマップコンテキストを作成
        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else { return [] }

        // CGContextに画像を描画してピクセルデータを取得
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return pixelData
    }
}
