//
//  TileLayout.swift
//  Fusion
//
//  Created by Charles Imperato on 12/23/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit

// - Protocol for the tile layout
protocol TileLayoutDelegate: class {
    // - Returns the height of the tile at the specified index path
    func collectionView(_ collectionView: UICollectionView, heightForTileAtIndexPath indexPath: IndexPath) -> CGFloat
}

class TileLayout: UICollectionViewLayout {
    
    // - Delegate
    weak var delegate: TileLayoutDelegate?
    
    // - Layout of two columns by default
    var numberOfColumns = 2

    // - Cell padding for each tile
    fileprivate var cellPadding: CGFloat = 5.0
    
    // - Cached layout attributes
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    // - Content height for the collection
    fileprivate var contentHeight: CGFloat = 0
    
    // - Content width of the collection view subtracting the insets
    fileprivate var contentWidth: CGFloat {
        guard let collection = self.collectionView else { return 0 }
        
        let insets = collection.contentInset
        return collection.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize.init(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collection = self.collectionView, let delegate = self.delegate else { return }
        
        let colWidth = self.contentWidth / CGFloat(self.numberOfColumns)

        var xOffset = [CGFloat]()
        for column in 0..<self.numberOfColumns {
            xOffset.append(CGFloat(column) * colWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0..<collection.numberOfItems(inSection: 0) {
            let indexPath = IndexPath.init(item: item, section: 0)
            
            let tileHeight = delegate.collectionView(collection, heightForTileAtIndexPath: indexPath)
            let height = self.cellPadding * 2 + tileHeight
            let frame = CGRect.init(x: xOffset[column], y: yOffset[column], width: colWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // - Create the attributes
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // - Calculate the content height and update the column
            contentHeight = max(self.contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // - Return the attributes that are in the rect
        return self.cache.filter { (attributes) -> Bool in
            attributes.frame.intersects(rect)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
}
