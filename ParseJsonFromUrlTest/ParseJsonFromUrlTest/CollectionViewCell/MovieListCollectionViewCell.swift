//
//  MovieListCollectionViewCell.swift
//  ParseJsonFromUrlTest
//
//  Created by Mehedi on 5/6/21.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topLineView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
