import LBTATools
import UIKit
import WebKit

class YoustersWKWebViewController: TommyViewController {
    
    let webView = WKWebView()
    
    init(url:String) {
        super.init(nibName: nil, bundle: nil)
        setupView()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.addSubview(webView)
        view.backgroundColor = .white
        webView.fillSuperview(padding: .init(top: 50, left: 0, bottom: 0, right: 0 ))
    }
    
}

