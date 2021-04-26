import UIKit

class QueueViewCell: UITableViewCell {
    
    var queue: Queue?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with queue: Queue) {
        self.queue = queue
        
        backgroundColor = .blackTransp
        
        subviews.forEach { $0.removeFromSuperview() }
        
        let doctorName = UILabel(text: queue.doctorName, font: Fonts.standart.gilroyRegular(ofSize: 23), textColor: .white, textAlignment: .left, numberOfLines: 0)
        
        let coreStack = stack(doctorName)
        coreStack.spacing = 5
        
        switch queue.status {
        case 0 where queue.membershipId == 0:
            let estimatedTime = UILabel(text: "Ваша очередь наступила", font: Fonts.standart.gilroySemiBoldName(ofSize: 15), textColor: .white, textAlignment: .left, numberOfLines: 0)
            coreStack.addArrangedSubview(estimatedTime)
        case 0:
            let estimatedTime = UILabel(text: "Примерное время ожидания: \(queue.waitingInMinutes.minutesToWait())", font: Fonts.standart.gilroySemiBoldName(ofSize: 15), textColor: .white, textAlignment: .left, numberOfLines: 0)
            coreStack.addArrangedSubview(estimatedTime)
        case 2:
            let status = UILabel(text: "Успешно посешено", font: Fonts.standart.gilroyMedium(ofSize: 14), textColor: .white, textAlignment: .left, numberOfLines: 0)
            coreStack.addArrangedSubview(status)
        case 3:
            let status = UILabel(text: "Очередь покинута", font: Fonts.standart.gilroyMedium(ofSize: 14), textColor: .white, textAlignment: .left, numberOfLines: 0)
            coreStack.addArrangedSubview(status)
        default:
            break
        }
    
        addSubview(coreStack)
        coreStack.fillSuperview()
        coreStack.layoutMargins = .allSides(20)
        coreStack.isLayoutMarginsRelativeArrangement = true
    }

}
