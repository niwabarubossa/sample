//
//  MyScrollViewController.swift
//  sample
//
//  Created by Ni Ryogo on 2020/07/03.
//  Copyright © 2020 Ni Ryogo. All rights reserved.
//

import UIKit

class MyScrollViewController: UIViewController {

    let maxZoomScale: CGFloat = 4.0
    let minZoomScale: CGFloat = 1.0

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.maximumZoomScale = maxZoomScale
        scrollView.minimumZoomScale = minZoomScale

        imageView = UIImageView(image: UIImage(named: "dog"))
        scrollView.addSubview(imageView)
    }

    // レイアウト更新後に呼ばれる
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let size = imageView.image?.size {
            // imageViewのサイズがscrollView内に収まるように調整
            let wrate = scrollView.frame.width / size.width
            let hrate = scrollView.frame.height / size.height
            let rate = min(wrate, hrate, 1)
            imageView.frame.size = CGSize(width: size.width * rate,
                                          height: size.height * rate)

            // contentSizeを画像サイズに設定
            scrollView.contentSize = imageView.frame.size
            // 初期表示のためcontentInsetを更新
            updateScrollInset()
        }
    }

    // ScrollViewをダブルタップしたら呼ばれる
    // TapGestureはStoryboard側で設定している
    @IBAction func doubleTapped(_ gesture: UITapGestureRecognizer) {
        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
            let newScale = self.scrollView.zoomScale * 2    // 現在より2倍拡大する
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // scaleがmaxなら1倍に戻す
            self.scrollView.setZoomScale(1.0, animated: true)
        }
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(
            width: self.scrollView.frame.size.width / scale,
            height: self.scrollView.frame.size.height / scale
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }

}

extension MyScrollViewController: UIScrollViewDelegate {

    // ズームに対応したViewを返す
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    // ズームのタイミングでcontentInsetを更新
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
    }

    // imageViewの大きさからcontentInsetを再計算
    private func updateScrollInset() {
        scrollView.contentInset = UIEdgeInsets(
            top: max((scrollView.frame.height - imageView.frame.height)/2, 0),
            left: max((scrollView.frame.width - imageView.frame.width)/2, 0),
            bottom: 0,
            right: 0
        )
    }
}
