//
//  HelperController.swift
//  Marvel-iOSApp
//
//  Created by Squad Apps on 26/12/23.
//

import UIKit

class HelperController: UIViewController {
    var alertForLoading = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    func setupLoadingAlert(completion: (() -> Void)? = nil) {
        alertForLoading.view.tintColor = UIColor.white
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:10, y:5, width: 50, height:50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alertForLoading.view.addSubview(loadingIndicator)
    }
    
    func showLoadingAlert() {
        self.present(alertForLoading, animated: true, completion: nil)
    }
    
    func dismissLoadingAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
