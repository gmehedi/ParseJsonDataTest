//
//  ViewController.swift
//  ParseJsonFromUrlTest
//
//  Created by Mehedi on 5/6/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var apiKey = "38e61227f85671163c275f9bd95a8803"
    var quary = "marvel"
    var movieModelArray = [MovieInfoModel]()
    var searchActive = false
    var searchTextF = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.jsonParser()
        self.searchBar.delegate = self
    }
    
}

extension ViewController {
    
    func jsonParser() {
        let urlPath = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(quary)"
        
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        
        print("URLPath  ", urlPath)
        let request = NSMutableURLRequest(url: endpoint)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                guard let data = data else{
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject> else {
                    return
                }
                print("Json  ", json)
                
                
                if let tempArray = json["results"] as? [Dictionary<String, AnyObject>] {
                    for item in tempArray {
                        let newItem = MovieInfoModel()
                        
                        if let temp = item as? Dictionary<String, AnyObject>{
                           // print("Here")
                            if let posterImageId  = temp["id"] as? Int64{
                                newItem.id = posterImageId
                            }
                
                            if let posterPath  = temp["poster_path"] as? String{
                                newItem.posterImage = posterPath
                            }
                            if let title  = temp["title"] as? String{
                                newItem.title = title
                            }
                            if let overView  = temp["overview"] as? String{
                                newItem.overView = overView
                            }
                            self.movieModelArray.append(newItem)
                        }
                        
                    }
                }
                print("self ", self.movieModelArray[0].id)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                print("error")
            }
        })
        task.resume()
    }
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //MARK: Setup CollectionView
    fileprivate func setupCollectionView(){
        self.registerCollectionViewCell()
        self.setCollectionViewFlowLayout()
        self.setCollectionViewDelegate()
        
    }
    
    //MARK: Registration nib file and Set Delegate, Datasource
    fileprivate func registerCollectionViewCell(){
        let menuNib = UINib(nibName: "MovieListCollectionViewCell", bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: "MovieListCollectionViewCell")
        
    }
    
    //MARK: Set Collection View Flow Layout
    fileprivate func setCollectionViewFlowLayout(){
        
        if let layoutMenu = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutMenu.scrollDirection = .vertical
            layoutMenu.minimumLineSpacing = 10
            layoutMenu.minimumInteritemSpacing = 10
        }
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    //ReloadSingle Cell
    fileprivate func reloadSingleCell(){
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        let cell = self.collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.reloadItems(at: [indexPath])
            cell?.layoutIfNeeded()
        })
    }
    
    //MARK: Set Collection View Delegate
    fileprivate func setCollectionViewDelegate(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var tempArray =  self.getArray()
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        cell.titleLabel.text = tempArray[indexPath.item].title
        cell.overViewLabel.text = tempArray[indexPath.item].overView
        if indexPath.item == 0 {
            cell.topLineView.isHidden = false
        }else{
            cell.topLineView.isHidden = true
        }
        print("TT  ", tempArray[indexPath.item].posterImage)
        var str1:String="\(tempArray[indexPath.item].id)"
        let link = "https://api.themoviedb.org/3/movie/{\(str1)}/images?api_key=\(apiKey)&language=en-US"
        
       // cell.imageView.image =
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String = ""
        text = self.movieModelArray[indexPath.item].overView
        let width = self.collectionView.bounds.width
        let titleH: CGFloat =  40
        let descriptionH: CGFloat = self.heightForView(text: text, font: UIFont.systemFont(ofSize: 16), width: collectionView.bounds.width)
        
        let height = max(132, descriptionH + titleH)
        //print("Height  ", height,"  ", text)
        return CGSize(width: width, height: height)
    }
    
}

extension ViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight : Int = Int(keyboardSize.height) - 20
            //print("keyboardHeight",keyboardHeight)
            self.collectionViewBottomConstraint.constant = CGFloat(keyboardHeight)
        }
    }
    
    func getArray() -> [MovieInfoModel] {
        var tempArra = [MovieInfoModel]()
        if searchTextF.count > 0 {
            for item in self.movieModelArray{
                
                if item.title.containsIgnoringCase(find: searchTextF){
                    tempArra.append(item)
                }
            }
        }
        
        if searchTextF.count == 0 {
            return movieModelArray
        }else{
           return tempArra
        }
    }
    
    func heightForView(text: String, font:UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

//MARK: SearchBar Delegate
extension ViewController: UISearchBarDelegate{
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            print("searchBarShouldBeginEditing")
            searchBar.showsCancelButton = true
            return true
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print("searchBarShouldBeginEditing222")
            self.collectionViewBottomConstraint.constant = 0
            searchActive =  false
            searchBar.showsCancelButton = false
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.resignFirstResponder()
            } else {
                searchBar.textField.resignFirstResponder()
            }
            searchTextF = ""
            searchBar.text = ""
            self.collectionView.reloadData()
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchBarShouldBeginEditing222")
            searchActive  = true
            searchTextF = searchText
            self.collectionView.reloadData()
        }
    }
