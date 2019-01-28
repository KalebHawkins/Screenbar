import Foundation

class ScreenShot : NSObject {
    
    lazy var dateFormatter = DateFormatter();
    
    private func getDate() -> String {
        let date = Date()
        self.dateFormatter.dateStyle = DateFormatter.Style.none
        self.dateFormatter.timeStyle = DateFormatter.Style.medium
        var dateString = self.dateFormatter.string(from: date)
        dateString = dateString.replacingOccurrences(of: ":", with: ".", options: NSString.CompareOptions.literal, range: nil)
        return dateString;
    }
    
    @objc func TakeScreenshot(timer: Timer ) {
        let dateString = self.getDate()
        var extention = "jpg"
        
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        
        var arguments = [String]();
        if(Settings.getPlaySound() == 0) {
            arguments.append("-x")
        }
        
        let format = timer.userInfo! as! Int
        print(format)
        if(format == 0){
            extention = "jpg"
        }
        else if(format == 1){
            extention = "png"
        }
        
        arguments.append(Settings.getPath().path + "/Screenshot-" + dateString + "." + extention)
        task.arguments = arguments
        
        task.launch()
    }
    
}
