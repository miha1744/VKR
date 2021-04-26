import UIKit

class FeedViewController: TommyViewController {
    
    let tableView = UITableView()
    let refresher = UIRefreshControl()
    
    var queues:[Queue] = []
        
    let cellID = "queueCell"
    
    let emptyLabel = UILabel(text: "Ничего не найдено", font: Fonts.standart.gilroyMedium(ofSize: 17), textColor: .lightGray, textAlignment: .center, numberOfLines: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if App.shared.isNeedReloadFeedData {
            getQueues()
            App.shared.isNeedReloadFeedData = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        emptyLabel.isHidden = true
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        
        //view.backgroundColor = .white
        navigationItem.title = "Ваши очереди"
        navigationItem.largeTitleDisplayMode = .always
        
        initView()
        
        getQueues()
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.register(QueueViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.fillSuperview()
        
        refresher.tintColor = .bgColor
        refresher.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    func getQueues() {
        beforeReq()
        QueueService.main.getMyQueues { [weak self] (result) in
            self?.applyNewQueue(result: result)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self?.getQueues()
            }
        }
    }
    
    func beforeReq() {
        showLoading(true)
        emptyLabel.isHidden = true
    }
    
    func updateCurrenQueueVC(with queues: [Queue]) {
        if let queueVC = App.shared.currentQueueVC, let queue = queues.first(where: { $0.id == queueVC.queue.id }) {
            queueVC.queue = queue
            queueVC.reload()
        }
    }
    
    func applyNewQueue(result: Result<[Queue], NetworkError>) {
        switch result {
        case .success(let data):
            self.queues = data
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !data.isEmpty
            self.updateCurrenQueueVC(with: data)
            
        case .failure(let error):
            print(error)
            break
        }
        self.showLoading(false)
        self.refresher.endRefreshing()
    }
    
    @objc func refresh(sender:AnyObject){
        getQueues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! QueueViewCell
        
        cell.configure(with: queues[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if queues[indexPath.row].status == 0 {
            let mixPage = QueuePageViewController(queue: queues[indexPath.row])
            navigationController?.pushViewController(mixPage, animated: true)
        }
    }
}
