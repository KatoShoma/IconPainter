//
//  IconPainterView.swift
//  IconPainter
//
//  Created by ShomaKato on 2024/03/14.
//

import UIKit

final class IconPainterView: UIView {
    private var cxxImagePainter = CxxImageProcessor()
    private let assetName = "icon_wave"

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        // 元画像
        let originalImage = UIImage(named: assetName)!

        // 1. swift-opencv
        let paintedImage = ImagePainter.imagePainting(assetName: assetName)!

        // 2. Objective-C++
        let objcPaintedImage = ObjcImagePainter.imagePainting(UIImage(named: assetName))!

        // 3. c++
        let imageWidth = originalImage.cgImage!.width
        let imageHeight = originalImage.cgImage!.height
        let assetNameStdString = std.string(assetName)


        let iconPixelValues = Array<UInt8>(
            cxxImagePainter.findContourFromUIImage(
                assetNameStdString,
                Int32(imageWidth),
                Int32(imageHeight)
            )
        )
        let cxxPaintedImage = ImagePainter.arrayToImage(pixelValues: iconPixelValues, width: imageWidth, height: imageHeight)!

        let iconImageTest = makeIconImageView(image: originalImage)
        let iconImageView = makeIconImageView(image: paintedImage)

        let stackView = UIStackView(arrangedSubviews: [iconImageTest, iconImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 50

        self.addSubview(stackView)

        // stackViewとiconImageViewの制約を設定
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            // イメージビューの高さと幅の制約を削除して、アスペクト比を維持
            iconImageTest.heightAnchor.constraint(equalToConstant: 200),
            iconImageTest.widthAnchor.constraint(equalToConstant: 200),
            iconImageView.heightAnchor.constraint(equalTo: iconImageTest.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageTest.widthAnchor)
        ])
    }

    private func makeIconImageView(image: UIImage, tintColor: UIColor? = nil, backgroundColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = tintColor ?? .clear
        imageView.backgroundColor = backgroundColor ?? .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
