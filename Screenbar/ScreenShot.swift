import Foundation

class ScreenShot : NSObject {
    
    lazy var dateFormatter = DateFormatter();
    
    // Returns the date. This will be used to name the screenshot.
    private func getDate() -> String {
        let date = Date()
        self.dateFormatter.dateStyle = DateFormatter.Style.none
        self.dateFormatter.timeStyle = DateFormatter.Style.medium
        var dateString = self.dateFormatter.string(from: date)
        dateString = dateString.replacingOccurrences(of: ":", with: ".", options: NSString.CompareOptions.literal, range: nil)
        return dateString;
    }
    
    @objc func TakeScreenshot(timer: Timer ) {
        // Get the date string from the previous function.
        let dateString = self.getDate()
        var extention = "jpg"
        
        // Create a process and take a screenshot with it.
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        
        // If the Play sound with capture box is unchecked we silence the command..
        var arguments = [String]();
        if(Settings.getPlaySound() == 0) {
            // screenshot -x <filePath> # -x means do not play a sound.
            arguments.append("-x")
        }
        
        // Determine what the format actually is
        // 0 = JPG/JPEG
        // 1 = PNG
        let format = timer.userInfo! as! Int
        print(format)
        if(format == 0){
            extention = "jpg"
        }
        else if(format == 1){
            extention = "png"
        }
        
        // Append the remainder of the arguments to the command. See man /usr/sbin/screenshot for more options.
        arguments.append(Settings.getPath().path + "/Screenshot-" + dateString + "." + extention)
        task.arguments = arguments
        
        // Launch the task.
        task.launch()
    }
    
}
