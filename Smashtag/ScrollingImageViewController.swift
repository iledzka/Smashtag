//
//  ScrollingImageViewController.swift
//  Smashtag
//
//  Created by Iza Ledzka on 10/01/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class ScrollingImageViewController: UIViewController {

    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                        self?.updateZoom()
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchData()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            
            scrollView.minimumZoomScale = 1
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    fileprivate var imageView = UIImageView()
    
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    private func updateZoom() {
        //calculate and set the scale when the size of image is known
        if let imageWidth = imageView.image?.size.width, let imageHeight =  imageView.image?.size.height {
            let widthAcpectRatio = max(imageWidth, scrollView.frame.size.width) / min(imageWidth, scrollView.frame.size.width)
            let heightAspectRatio = max(imageHeight, scrollView.frame.size.height) / min(imageHeight, scrollView.frame.size.height)
            scrollView.maximumZoomScale = max(widthAcpectRatio, heightAspectRatio)
            scrollView.zoomScale = max(widthAcpectRatio, heightAspectRatio)
        }
        
    }
}

extension ScrollingImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

