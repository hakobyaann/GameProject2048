//
//  UIViewBlock.swift
//  GameProject2048
//
//  Created by Anna Hakobyan on 27.09.23.
//

import UIKit

final class BlockView: UIView {
    var number = 0
    var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
       }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(image)
        
        // Setting up constraints for the imageView to fill the BlockView
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
