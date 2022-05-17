//
//  OpeningController.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/10/22.
//

import UIKit

protocol OpeningNavigationDelegate {
    func navigateToLogin(from viewController: OpeningViewController)
    func navigateToSignUp(from viewController: OpeningViewController)
}

final class OpeningViewController: UIViewController {
    
    let primaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
    }
    
    let secondaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 5
        stackView.axis = .horizontal
    }
    
    let logoImageView: UIImageView = .build { imageView in
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo-Icon")
    }
    
    let primaryLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.text = "Welcome to"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 32)
    }
    
    let secondaryLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.text = "Exchange"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 42, weight: .black)
    }
    
    let tertiaryLabel: UILabel = .build { label in
        label.numberOfLines = 2
        label.textColor = .white
        label.minimumScaleFactor = 0.5
        label.font = .systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.text = NSLocalizedString("OPENING_SUBHEADER", comment: "Subheader")
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(10)
        button.backgroundColor = .white
        button.setTitle(NSLocalizedString("GET_STARTED", comment: "Button"), for: .normal)
        button.setTitleColor(.darkThemeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        return button
    }()
    
    let loginLabel: UILabel = .build { label in
        label.numberOfLines = 5
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        label.text = "Already have an account?"
    }
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
    
    public var navigationDelegate: OpeningNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        addSubviews()
        setCustomSpacing()
        configureConstraints()
        view.setVerticalGradientBackground(
            topColor: .lightThemeColor,
            bottomColor: .darkThemeColor
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func addTargets() {
        logInButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(primaryStackView)
        view.addSubview(secondaryStackView)
        primaryStackView.addArrangedSubview(logoImageView)
        primaryStackView.addArrangedSubview(primaryLabel)
        primaryStackView.addArrangedSubview(secondaryLabel)
        primaryStackView.addArrangedSubview(tertiaryLabel)
        primaryStackView.addArrangedSubview(signUpButton)
        secondaryStackView.addArrangedSubview(loginLabel)
        secondaryStackView.addArrangedSubview(logInButton)
    }
    
    private func setCustomSpacing() {
        primaryStackView.setCustomSpacing(-5, after: primaryLabel)
        primaryStackView.setCustomSpacing(5, after: secondaryLabel)
    }
    
    private func configureConstraints() {
        [primaryStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         primaryStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
         primaryStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
         secondaryStackView.leftAnchor.constraint(equalTo: primaryStackView.leftAnchor),
         secondaryStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30),
         logoImageView.heightAnchor.constraint(equalToConstant: 80),
         logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
         signUpButton.heightAnchor.constraint(equalToConstant: 55),
         signUpButton.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor),
        ].activate()
    }
    
    @objc private func signUpTapped() {
        navigationDelegate?.navigateToSignUp(from: self)
    }
    
    @objc private func logInTapped() {
        navigationDelegate?.navigateToLogin(from: self)
    }
    
}
