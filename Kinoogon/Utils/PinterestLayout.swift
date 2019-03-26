//
//  PinterestLayout.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 3/25/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class PinterestLayout: UICollectionViewLayout {
    var numberOfColumns: CGFloat = 2
    var cellPadding: CGFloat = 0
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return (collectionView!.bounds.width - (insets.left + insets.right))
    }
    
    private var attributesCache = [PinterestLayoutAttributes]()
    
    override func prepare() {
        attributesCache = []
        if collectionView!.numberOfItems(inSection: 0) == 0 {
            contentHeight = 0
        }
        //if attributesCache.isEmpty {
        let columnWidth = (contentWidth / 5) * 2
        var xOffsets = [CGFloat]()
        for column in 0 ..< Int(numberOfColumns) {
            print("columnWidthcolumnWidth \(contentWidth) \(contentWidth / 15)")
            print("CGFloat(column) * columnWidth \(CGFloat(column) * columnWidth + CGFloat(column + 1) * contentWidth / 15)")
            xOffsets.append(CGFloat(column) * columnWidth + CGFloat(column + 1) * contentWidth / 15 )
        }
        
        var column = 0
        var yOffsets = [CGFloat](repeating: 0, count: Int(numberOfColumns))
        
        //-----
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            //print("item \(indexPath)")
            
            // calculate the frame
            let width = columnWidth - cellPadding * 2
            let photoHeight: CGFloat
            photoHeight = width / 9 * 16
//            if item != 1 {
//                photoHeight = width / 9 * 16
//            } else {
//                photoHeight = width / 9 * 8
//            }
            
            //let height: CGFloat = photoHeight + cellPadding * 2
            let height: CGFloat = item == 0 || item == 1 ? photoHeight + 20 : photoHeight
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            //let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            //let insetFrame = frame.insetBy(dx: cellPadding, dy: 0)
            var insetFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
            if item == 0 || item == 1 {
                insetFrame = frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
            } else {
                //print("item != 0 || item != 1")
                insetFrame = frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
            }
            // create layout attributes
            let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
            if item == 0 || item == 1 {
                attributes.photoHeight = photoHeight + 20
            } else {
                attributes.photoHeight = photoHeight
            }
            
            attributes.frame = insetFrame
            attributesCache.append(attributes)
            
            // update column, yOffset
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
            
            if column >= (Int(numberOfColumns) - 1) {
                column = 0
            } else {
                column += 1
            }
        }
        //}
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes
{
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        
        return false
    }
}
