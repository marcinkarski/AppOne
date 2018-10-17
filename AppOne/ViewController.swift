import UIKit

class ViewController: UIViewController {
    
    private var isViewControllerInitialized = false
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard !self.isViewControllerInitialized else {
            return
        }
        self.isViewControllerInitialized = true
        self.navigationController?.pushViewController(DetailViewController(), animated: true)
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
    
    public func presentDetailView() {
        let detailViewController = DetailViewController()
        detailViewController.modalPresentationStyle = .overCurrentContext
        present(detailViewController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
    
    let viewController = ViewController()
    let imageCell = ImageCell()
    let service = APIService()
    let user = "marcinkarski"
    var tasks = [URLSessionDataTask]()
    
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
        fetchUsers()
    }
    
    private func setup() {
        addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
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

private extension TopCell {
    
    func loadData(withUsername username: String) {
        loadProfile(withUsername: username)
    }
    
    func loadProfile(withUsername username: String) {
        let base: String = "https://api.github.com/users/"
        guard let url = URL(string: base + username) else { return }
        let task = service.request(url) { [weak self] (result: Result<Profile>) in
            switch result {
            case .success(let profile):
                self?.imageCell.configure(with: profile)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tasks.append(task)
    }
    
    func fetchUsers() {
        tasks.forEach { $0.cancel() }
//        let usersArray: [String] = viewController.users

//        let trimmedName = usersArray.filter({ " ".contains($0) == false })
        loadData(withUsername: user)
        print(user)
    }
}

class ImageCell: UICollectionViewCell {
    
    let service = APIService()
    var imageRequest: URLSessionDataTask?
    
    let imageView: UIImageView = {
        let placeholder = UIImage(named: "bottomViewImagePlaceholder")
        let imageView = UIImageView(image: placeholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        imageView.addSubview(activityIndicator)
        let constraints = [imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                           imageView.topAnchor.constraint(equalTo: topAnchor),
                           imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                           imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                           activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with profile: Profile) {
        loadImage(for: profile)
    }
    
    func loadImage(for profile: Profile) {
        guard let url = URL(string: profile.avatarURL) else { return }
        imageRequest = service.requestImage(withURL: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        collectionView.isUserInteractionEnabled = true
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
        if let cell = collectionView.cellForItem(at: indexPath) as? NameCell {
            cell.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                cell.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            }
            let detailViewController = DetailViewController()
            guard let cellName = cell.nameLabel.text else { return }
            let trimmedName = cellName.filter({ " ".contains($0) == false })
            detailViewController.selectedName = trimmedName.lowercased()
            viewController.presentDetailView()
//            let user = viewController.users[indexPath.row]
//                viewController.presentDetailView(user: user)
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
        nameLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
