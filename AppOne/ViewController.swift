import UIKit

class ViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(collectionView)
        let constraints = [collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                           collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
}
