import SwiftyJSON
import SwiftDate

class Queue {
    var id: Int,
        patientId: Int,
        doctorQueue: Int,
        joinedAt: Date,
        membershipId: Int,
        status: Int,
        secondsInQueue: Int,
        waitingInMinutes: Int,
        doctorName: String
    
    
    init(data:JSON) {
        print(data)
        id = data["pk"].intValue
        patientId = data["patient"].intValue
        doctorQueue = data["Doctorqueue"].intValue
        joinedAt = data["date_joined"].stringValue.toDate(style: .sql)?.date ?? Date()
        membershipId = data["membershipId"].intValue
        status = data["status"].intValue
        secondsInQueue = data["provedeno_vremeni_v_ocherede_v_secundah"].intValue
        waitingInMinutes = data["primerno_ostalos_zhdat_v_minutah"].intValue
        doctorName = data["chto_za_doctor"].stringValue
    }
}
