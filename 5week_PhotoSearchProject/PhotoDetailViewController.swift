//
//  PhotoDetailViewController.swift
//  5week_PhotoSearchProject
//
//  Created by sumin on 2021/10/13.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    
    var imageURLString: String = ""
    var imageURL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(imageURLString)
        
        imageURL = URL(string: imageURLString)
        
        fromUrltoImage(url: imageURL!)
    }
    
    
    func fromUrltoImage(url: URL) {
        
//        if let url = user?.kakaoAccount?.profile?.profileImageUrl,
//            let data = try? Data(contentsOf: url) {
//            self.profileImageView.image = UIImage(data: data)
//        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.detailImage.image = image
                    }
                }
            }
        }
    }
    
    
    @IBAction func clickBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
