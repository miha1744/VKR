import SwiftDate
import UIKit

class QueuePageViewController: TommyStackViewController {
    
    var queue: Queue
    private lazy var loadingAlert = UIAlertController(style: .loading)
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        App.shared.currentQueueVC = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        App.shared.currentQueueVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = queue.doctorName
        navigationItem.largeTitleDisplayMode = .always
        
        scrollView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        stackView.alignment = .center
        
        initView()
    }

    init(queue: Queue) {
        self.queue = queue
        super.init(nibName: nil, bundle: nil)
    }
    
    func initView() {
        
        switch queue.status {
        case 0 where queue.membershipId == 0:
            setupGoToDoctor()
        case 0:
            setupActiveQueue()
        default:
            break
        }
    }
    
    func setupGoToDoctor() {
        let minutesTextLabel = UILabel(text: "Ваша очередь", font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .white, textAlignment: .center, numberOfLines: 0)
        addWidthArrangedSubView(view: minutesTextLabel)
        
        let exitButton = TommyButton(text: "Выйти из очереди", style: .secondary)
        exitButton.addOnTapTarget {
            self.present(self.loadingAlert, animated: true, completion: nil)
            QueueService.main.quitQueue(doctorQueue: String(self.queue.doctorQueue)) { result in
                self.loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success(let success):
                        if success {
                            App.shared.isNeedReloadFeedData = true
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let errorAlert = UIAlertController(style: .errorMessage)
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                    case .failure(_):
                        let errorAlert = UIAlertController(style: .errorMessage)
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        addWidthArrangedSubView(view: exitButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupActiveQueue() {
        let minutesLabel = UILabel(text: "\(queue.waitingInMinutes)", font: Fonts.standart.gilroySemiBoldName(ofSize: 100), textColor: .white, textAlignment: .center, numberOfLines: 0)
        addWidthArrangedSubView(view: minutesLabel)
        
        let minutesTextLabel = UILabel(text: "Минут", font: Fonts.standart.gilroySemiBoldName(ofSize: 35), textColor: .white, textAlignment: .center, numberOfLines: 0)
        addWidthArrangedSubView(view: minutesTextLabel)
        
        let minutesTextDescLabel = UILabel(text: "Примерное время ожидания", font: Fonts.standart.gilroySemiBoldName(ofSize: 17), textColor: .white, textAlignment: .center, numberOfLines: 0)
        addWidthArrangedSubView(view: minutesTextDescLabel)
        
        addInfo(title: (Date() - (queue.secondsInQueue.seconds)).timeAgo(numericDates: false), sub: "Вы встали в очередь")
        
        let exitButton = TommyButton(text: "Выйти из очереди", style: .secondary)
        exitButton.addOnTapTarget {
            self.present(self.loadingAlert, animated: true, completion: nil)
            QueueService.main.quitQueue(doctorQueue: String(self.queue.doctorQueue)) { result in
                self.loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success(let success):
                        if success {
                            App.shared.isNeedReloadFeedData = true
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            let errorAlert = UIAlertController(style: .errorMessage)
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                    case .failure(_):
                        let errorAlert = UIAlertController(style: .errorMessage)
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        addWidthArrangedSubView(view: exitButton)
    }
    

}

extension QueuePageViewController: ReloadProtocol {
    
    func reload() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        initView()
    }
}
