//
//  HelperController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 26/12/23.
//

import UIKit

class HelperController: UIViewController {
    
    lazy var alertForLoading = UIAlertController(title: "Please wait", message: "Loading data...", preferredStyle: .alert)
    lazy var alertForError = UIAlertController(title: "Error!", message: "Something went wrong, please try again!", preferredStyle: .alert)
    
    func setupAlerts() {
        setupErrorAlert()
        setupLoadingAlert()
    }
    
    //MARK: Loading alert
    func setupLoadingAlert() {
        alertForLoading.view.tintColor = UIColor(named: "textColor") ?? UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width: 50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alertForLoading.view.addSubview(loadingIndicator)
    }
    
    func showLoadingAlert() {
        self.present(alertForLoading, animated: true, completion: nil)
    }
    
    func dismissLoadingAlert(completion: (() -> Void)? = nil) {
        alertForLoading.dismiss(animated: true) {
            completion?()
        }
    }
    
    //MARK: Error alert
    func setupErrorAlert(completion: (() -> Void)? = nil){
        alertForError.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in completion?()}))
    }
    
    func showErrorAlert(message: String?) {
        if let message = message {
            self.alertForError.message = message
        }
        self.present(alertForError, animated: true, completion: nil)
    }
    
}
