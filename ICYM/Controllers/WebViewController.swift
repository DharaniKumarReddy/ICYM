//
//  WebViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 09/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    // MARK:- Variables
    internal var webUrlString: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var navigatonBarTopConstraint: NSLayoutConstraint!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationBackWithNoText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigatonBarTopConstraint.constant = screenHeight > 812 ? 44 : 20
        loadWebView()
    }
    
    // MARK:- IBActions
    @IBAction private func backButton_Tapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Private Methods
    private func loadWebView() {
        let urlRequest = NSURLRequest(url: NSURL(string: webUrlString ?? "http://youthactiv8.com/icym_app/about.html")! as URL)
        webView.loadRequest(urlRequest as URLRequest)
    }
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
        loadingIndicator.stopAnimating()
    }
}
