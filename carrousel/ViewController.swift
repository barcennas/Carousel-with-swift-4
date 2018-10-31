//
//  ViewController.swift
//  carrousel
//
//  Created by Abraham Barcenas on 10/30/18.
//  Copyright © 2018 Abraham Barcenas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionBanner: UICollectionView!
    var pageControlBanner: UIPageControl!
    var images : [UIImage] = [#imageLiteral(resourceName: "image1"),#imageLiteral(resourceName: "image2"),#imageLiteral(resourceName: "image3")]
    
    var isBannerInChangeAnimation = false
    var isInAutomaticChange = false

    override func viewDidLoad() {
        super.viewDidLoad()
        createBanner()
    }
    
    func createBanner(){
        let collectionWidth = UIScreen.main.bounds.width - 20
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let itemSpacing: CGFloat = 3
        let itemsInOneLine: CGFloat = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = collectionWidth - itemSpacing * CGFloat(itemsInOneLine - 1)
        layout.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        
        collectionBanner = UICollectionView(frame: CGRect(x: 10, y: 50, width: collectionWidth, height: 155), collectionViewLayout: layout)
        collectionBanner.showsHorizontalScrollIndicator = false
        collectionBanner.dataSource = self
        collectionBanner.delegate = self
        collectionBanner.register(UINib(nibName: "CarouselCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCell")
        collectionBanner.backgroundColor = .white
        collectionBanner.tag = 45
        
        view.addSubview(collectionBanner)
        
        pageControlBanner = UIPageControl(frame: CGRect(x: 10, y: 165, width: collectionWidth, height: 20))
        pageControlBanner.numberOfPages = images.count
        pageControlBanner.currentPageIndicatorTintColor = #colorLiteral(red: 0.2330989242, green: 0.2317195535, blue: 0.2341632545, alpha: 1)
        pageControlBanner.pageIndicatorTintColor = #colorLiteral(red: 0.231372549, green: 0.2317195535, blue: 0.2341632545, alpha: 0.5)
        view.addSubview(pageControlBanner)
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextPage (){
        isInAutomaticChange = true
        let currentPosition = pageControlBanner.currentPage + 1
        if currentPosition < images.count {
            let bannerWidth = UIScreen.main.bounds.width - 20
            let offset = bannerWidth * CGFloat(currentPosition)
            collectionBanner.scrollRectToVisible(CGRect(x: offset, y: 0, width: collectionBanner.frame.width, height: collectionBanner.frame.height), animated: true)
        }else{
            collectionBanner.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionBanner.frame.width, height: collectionBanner.frame.height), animated: true)
        }
    }


}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = images[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.imgView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image selected: ", indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bannerWidth = UIScreen.main.bounds.width - 20
        let halfOfBannerWidth = bannerWidth / 2
        let currentPage = CGFloat(pageControlBanner.currentPage + 1)
        
        let nextOffset = bannerWidth * currentPage
        let previousOffset = bannerWidth * (currentPage - 2)
        let pointOfPreviousChange = (bannerWidth * (currentPage - 1)) - halfOfBannerWidth
        let pointOfNextChange = (bannerWidth * currentPage) - halfOfBannerWidth
        
        if !isBannerInChangeAnimation && !isInAutomaticChange {
            if scrollView.bounds.minX >= pointOfNextChange{
                isBannerInChangeAnimation = true
                scrollView.setContentOffset(CGPoint(x: nextOffset, y: 0), animated: true)
            }else if scrollView.bounds.minX <= pointOfPreviousChange{
                scrollView.setContentOffset(CGPoint(x: previousOffset, y: 0), animated: true)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let midX:CGFloat = scrollView.bounds.midX
        let midY:CGFloat = scrollView.bounds.midY
        let point:CGPoint = CGPoint(x:midX, y:midY)
        
        guard let indexPath:IndexPath = collectionBanner.indexPathForItem(at:point) else { return }
        
        let currentPage = indexPath.item
        pageControlBanner.currentPage = currentPage
        
        isBannerInChangeAnimation = false
        isInAutomaticChange = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && !isBannerInChangeAnimation{
            let currentPage = CGFloat(pageControlBanner.currentPage)
            let bannerWidth = UIScreen.main.bounds.width - 20
            let offset = bannerWidth * currentPage
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
}

