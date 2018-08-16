//
//  AnswersCollectionFlowLayout.swift
//  Grocery Challenge
//
//  Created by Aylwing Olivas on 8/16/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

final class AnswersCollectionFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Public properties
    var horizontalSizeClass: UIUserInterfaceSizeClass?

    // MARK: - Private properties
    private var cellPadding: CGFloat = 5
    private var layoutContentHeight: CGFloat = 0
    private var layoutAttributesCache: [UICollectionViewLayoutAttributes] = []

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    private var numberOfColumns: Int {
        let availableWidth = contentWidth
        let columns: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 4 : 2
        let minimumColumnWidth: CGFloat = contentWidth / columns
        let maximumNumberOfColumns = Int(availableWidth / minimumColumnWidth)
        return maximumNumberOfColumns
    }

    // MARK: - Overrides
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: layoutContentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var attributesArray: [UICollectionViewLayoutAttributes] = []
        guard let firstMatchIndex = getIndexForAttributeIntersecting(rect: rect) else { return attributesArray }

        for attributes in layoutAttributesCache[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }

        for attributes in layoutAttributesCache[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }

        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesCache[indexPath.item]
    }

    func updateNumberOfColumns() {
        invalidateLayout()
        layoutContentHeight = 0
        layoutAttributesCache.removeAll()
        collectionView?.setCollectionViewLayout(self, animated: true)
        collectionView?.reloadData()
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        setFlowLayoutGrid(for: collectionView)
    }

    // MARK: - Private functions
    private func setFlowLayoutGrid(for collectionView: UICollectionView) {

        var columnIndex = 0
        let twoSides: CGFloat = 2
        let sideInset = 24 / twoSides
        let bottomInset = 16 / twoSides
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let xOffsets = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        // Iterates through the list of items in the first and only section
        for item in 0..<collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)
            let newHeight = cellPadding * twoSides + columnWidth
            let frame = CGRect(x: xOffsets[columnIndex], y: yOffset[columnIndex], width: columnWidth, height: newHeight)
            let insetFrame = frame.insetBy(dx: sideInset, dy: bottomInset)

            // Creates a UICollectionViewLayoutItem with the frame and adds it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributesCache.append(attributes)

            // Updates the collection view content height
            layoutContentHeight = max(layoutContentHeight, frame.maxY)
            yOffset[columnIndex] = yOffset[columnIndex] + newHeight
            columnIndex = columnIndex < numberOfColumns - 1 ? columnIndex + 1 : 0
        }
    }

    /// Binary Search algorithm for finding the index of an intersecting layout attribute frame for `rect` parameter

    // This is faster in than using `.filter` since that would run in O(n)
    private func getIndexForAttributeIntersecting(rect: CGRect) -> Int? {

        var lowerBound = layoutAttributesCache.startIndex
        var upperBound = layoutAttributesCache.endIndex

        while lowerBound < upperBound {

            let midPoint = lowerBound + (upperBound - lowerBound) / 2
            if layoutAttributesCache[midPoint].frame.intersects(rect) {
                return midPoint
            } else if layoutAttributesCache[midPoint].frame.minY < rect.maxY {
                lowerBound = midPoint + 1
            } else {
                upperBound = midPoint
            }
        }

        return nil
    }
}
