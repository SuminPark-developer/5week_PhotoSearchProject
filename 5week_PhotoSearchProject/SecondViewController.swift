//
//  SecondViewController.swift
//  5week_PhotoSearchProject
//
//  Created by sumin on 2021/10/12.
//

import UIKit



class SecondViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var results: [Result] = []

    @IBOutlet weak var searchBar: UISearchBar!
//    let searchBar = UISearchBar()
    @IBOutlet weak var collectionView: UICollectionView!
//    private var collectionView: UICollectionView?
    
    var loginMethod: String = "" // 카카오 로그인 or 네이버 로그인 구분을 위해.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
//        view.addSubview(searchBar)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout // 셀 크기 지정 - https://k-elon.tistory.com/26
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
//        view.addSubview(collectionView)
//        collectionView.backgroundColor = .systemBackground
//        self.collectionView = collectionView
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
//        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
//    }
    
    @IBAction func clickHeartButton(_ sender: UIButton) {
        
    }
    
    @IBAction func clickProfileButton(_ sender: UIButton) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileViewController
        profileVC?.loginMethod = loginMethod
        self.navigationController?.pushViewController(profileVC!, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = [] // 검색 전, 콜렉션 뷰 초기화
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }

    // Api Request
    func fetchPhotos(query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=mUPbq2J5FWTSQ5tVi2Zd5pMQsFfv-zg35tk-719BxMw"
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
    

}


extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row + 1)")
        
        let imageURLString = results[indexPath.row].urls.regular // 컬렉션뷰 cell의 데이터 → 새로운 VC에 전달하는 방법. -  https://stackoverflow.com/questions/41831994/how-to-pass-collection-view-data-to-a-new-view-controller
        
        let photoVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailVC") as? PhotoDetailViewController
        photoVC!.imageURLString = imageURLString
        self.navigationController?.pushViewController(photoVC!, animated: true)
        
        
    }
    
    
}
