import Foundation

let dateFormatter = DateFormatter() // https://developer.apple.com/documentation/foundation/dateformatter

// MARK: - dateFormat
// see: https://stackoverflow.com/a/52297497
/*
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 */
dateFormatter.dateFormat = "yyyy-MM-dd a HH:mm:ss"

// MARK: - Date -> String
let dateStringEn = dateFormatter.string(from: Date())
print("Date -> String (en_001) \(dateStringEn)")

// MARK: Locale
print("before to change locale: \(dateFormatter.locale)")
dateFormatter.locale = Locale(identifier: "ko_KR")
print("after to change locale: \(dateFormatter.locale)")
let dateStringKo = dateFormatter.string(from: Date())
print("Date -> String (ko_KR) \(dateStringKo)")

// MARK: - String -> Date
let rawLocalizedString = "2025-01-01 오전 00:00:00"
let convertedDate = dateFormatter.date(from: rawLocalizedString)!
print(convertedDate)

dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
let rawTimestamp = "2025-01-15T14:12:25+0900"
let convertedDate2 = dateFormatter.date(from: rawTimestamp)!
print(convertedDate2)

let dummyData = "2025!01!15!!!!14:12:25!0900"
let trial = dateFormatter.date(from: dummyData)
print("suceess: \(trial != nil)")
