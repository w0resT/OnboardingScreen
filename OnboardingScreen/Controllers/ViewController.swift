import UIKit

class ViewController: UIPageViewController {
    
    // MARK: - Private Properties
    private var pages = [UIViewController]()
    private var currentPage = 0
    
    // MARK: - Public Properties
    let initialPage = 0
    
    // MARK: - UI Elements
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.pageIndicatorTintColor = Colors.secondary
        pageControl.currentPageIndicatorTintColor = Colors.primary
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.primary
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(Colors.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.primary
        button.setTitle("Next", for: .normal)
        button.setTitleColor(Colors.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.secondary
        button.setTitle("GET STARTED", for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.setTitleColor(Colors.lightGray, for: .highlighted)
        button.backgroundColor = Colors.primary
        button.layer.cornerRadius = 8
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
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

// MARK: - UI Setup
private extension ViewController {
    func setupUI() {
        self.view.backgroundColor = .white
        
        setupPageControl()
        setupBottomStack()
    }
    
    func setupPageControl() {
        // Setup
        delegate = self
        dataSource = self
        
        let page1 = OnboardingViewController(imageName: "png1", text: "Manage your home by using your phone everywhere")
        let page2 = OnboardingViewController(imageName: "png2", text: "Link your home by plugging them and connect to Wi-fi")
        let page3 = OnboardingViewController(imageName: "png3", text: "Instant notification of you about any incident")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)

        // Layout
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -130)
        ])
    }
    
    func setupBottomStack() {
        // Setup
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        getStartedButton.addTarget(self, action: #selector(startedTapped), for: .touchUpInside)
        
        
        // Layout
        view.addSubview(bottomStack)
        
        bottomStack.addArrangedSubview(skipButton)
        bottomStack.addArrangedSubview(nextButton)
        bottomStack.addArrangedSubview(getStartedButton)
        
        NSLayoutConstraint.activate([
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            getStartedButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}

// MARK: - Actions
private extension ViewController {
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: currentPage > sender.currentPage ? .reverse : .forward, animated: true)
        
        currentPage = sender.currentPage
        animateButtonsIfNeeded()
    }
    
    @objc func skipTapped(_ sender: UIButton) {
        let lastPageIdx = pages.count - 1
        pageControl.currentPage = lastPageIdx
        currentPage = lastPageIdx
        
        goToSpecificPage(index: lastPageIdx, atViewControllers: pages)
        animateButtonsIfNeeded()
    }
    
    @objc func nextTapped(_ sender: UIButton) {
        pageControl.currentPage += 1
        currentPage += 1
        
        goToNextPage()
        animateButtonsIfNeeded()
    }
    
    @objc func startedTapped(_ sender: UIButton) {
        print("Get Started Action")
    }
}

// MARK: - UIPageViewControllerDataSource
extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIdx = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIdx != 0 {
            return pages[currentIdx - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIdx = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIdx < pages.count - 1 {
            return pages[currentIdx + 1]
        }
        
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate
extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIdx = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIdx
        
        animateButtonsIfNeeded()
    }
}

// MARK: - Extension
private extension ViewController {
    func animateButtonsIfNeeded() {
        let isLastPage: Bool = pageControl.currentPage == pages.count - 1
        
        // TODO: Constraints + layoutIfNeeded
        UIView.animate(withDuration: 0.12) {
            if isLastPage {
                self.getStartedButton.isHidden = false
                self.skipButton.isHidden = true
                self.nextButton.isHidden = true
            }
            else {
                if self.getStartedButton.isHidden == false {
                    self.getStartedButton.isHidden = true
                    self.skipButton.isHidden = false
                    self.nextButton.isHidden = false
                }
            }
        }
    }
    
    func goToNextPage() {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: true)
    }
    
    func goToSpecificPage(index: Int, atViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true)
    }
}
