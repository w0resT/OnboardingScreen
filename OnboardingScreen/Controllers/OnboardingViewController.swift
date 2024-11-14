import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 90
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.primary
        label.textColor = Colors.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    init(imageName: String, text: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Setup UI
private extension OnboardingViewController {
    func setupUI() {
        setupStackView()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -230),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65)
        ])
    }
}
