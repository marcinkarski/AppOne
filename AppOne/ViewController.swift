import UIKit

class ViewController: UIViewController {
    
    let users = ["Ash Furrow", "John Sundell", "Todd Kramer", "James Rochabrun", "Jesse Squires"]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: "TopCell")
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.title = "GitHub Profiles"
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        let constraints = [collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                           collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
            cell.backgroundColor = .lightGray
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 3)
    }
}

// MARK: TopCell setup

class TopCell: UICollectionViewCell {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        let constraints = [collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                           collectionView.topAnchor.constraint(equalTo: topAnchor),
                           collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                           collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        cell.backgroundColor = .yellow
        return cell
    }
}

extension TopCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height / 1.8, height: frame.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

// MARK: CategoryCell setup

class CategoryCell: UICollectionViewCell {
    
    let viewController = ViewController()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NameCell.self, forCellWithReuseIdentifier: "NameCell")
        let constraints = [collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                           collectionView.topAnchor.constraint(equalTo: topAnchor),
                           collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                           collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCell", for: indexPath) as! NameCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        cell.nameLabel.text = viewController.users[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                cell.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            }
        }
    }
}

extension CategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: (frame.height - 5) / 5)
    }
}

class NameCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.backgroundColor = .clear
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(nameLabel)
        let constraints = [nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                           nameLabel.topAnchor.constraint(equalTo: topAnchor),
                           nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                           nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
