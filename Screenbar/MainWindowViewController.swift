import Cocoa

class MainWindowViewController: NSViewController {
    
    // Linked labels, buttons, textboxes, etc
    @IBOutlet weak var CaptureScreenshot: NSButton!
    @IBOutlet weak var secondsTextBox: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var path: NSPathControl!
    @IBOutlet weak var screenshotFormat: NSPopUpButton!
    @IBOutlet weak var playSound: NSButton!
    @IBOutlet weak var quit: NSButton!
    
    
    // Declares Timer to count seconds and creates a screenshot handler for Screenshot.swift.
    var timer: Timer = Timer()
    let screenshotHandler = ScreenShot()
    
    // Set the initial values of all the parameters.
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setSeconds()
        self.hideError()
        self.setPath()
        self.setPlaySound()
        self.setFormat()
    }
    
    
    // Save the second interval, path, and option to play sound settings.
    func saveSettings(_ seconds: Double?, path: URL?, playSound: Int) {
        Settings.setSecondsIntervall(seconds)
        Settings.setPath(path)
        Settings.setPlaySound(playSound)
    }
    
    // Tests to see if settings are valid.
    func saveSettings() -> Bool {
        var success = true;
        
        // Convert the seconds to a Double
        let seconds: Double? = Double(self.secondsTextBox.stringValue)
        
        // Get the path and sound state.
        let path: URL? = self.path.url
        let playSound = self.playSound.state
        
        // If the seconds were invalid then show an error.
        if(seconds == nil) {
            self.showError()
            success = false;
        }
        else { // Otherwise we hide the error and set the parameters.
            self.hideError()
            self.saveSettings(seconds, path: path, playSound: playSound.rawValue)
        }
        return success;
    }
    
    @IBAction func CaptureScreenshots(_ sender: Any) {
        // If saving the settings is successful; begin automatic screenshot captures.
        if(self.saveSettings()) {
            self.automaticScreenshot()
        }
    }
    
    func automaticScreenshot() {
        // If the time is running; display to stop the captures
        if(self.timer.isValid) {
            self.stopAutomaticScreenShot()
        }
        else { // If the time is not running; display to start the captures.
            self.startAutomaticScreenshot()
        }
    }
    
    // The logic behind changnig the label text on the Start Capture button.
    func ChangeTitleOfButton(_ title:String) {
        self.CaptureScreenshot.title = title
    }
    
    // Invalidates the timer and changes the label.
    func stopAutomaticScreenShot() {
        self.timer.invalidate()
        self.ChangeTitleOfButton("Capture automatic screenshot")
    }
    
    // Validates the timer and changes the label.
    func startAutomaticScreenshot() {
        let seconds = Settings.getSecondsInterval()
        
        let item = screenshotFormat.indexOfSelectedItem
        
        self.timer = Timer.scheduledTimer(timeInterval: seconds!, target: screenshotHandler, selector: #selector(ScreenShot.TakeScreenshot ), userInfo: ["format": item], repeats: true)
        self.ChangeTitleOfButton("Stop automatic screenshot")
    }
    
    // Get the seconds value from the text box.
    func setSeconds() {
        let seconds: Double? = Settings.getSecondsInterval()
        self.secondsTextBox.stringValue = String(seconds!)
    }
    
    // Set Play sound state
    func setPlaySound() {
        self.playSound.state = convertToNSControlStateValue(Settings.getPlaySound())
    }
    
    // Shows error message
    func showError() {
        self.errorMessage.isHidden = false
    }
    
    // Hides error message
    func hideError() {
        self.errorMessage.isHidden = true
    }
    
    // Sets the path
    func setPath() {
        self.path.url = Settings.getPath() as URL
        self.path.allowedTypes = nil
    }
    
    // Hides the app
    func close() {
        let appDelegate : AppDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hideMainWindow(self)
    }
    
    func setFormat(){
        screenshotFormat.removeAllItems()
        screenshotFormat.addItem(withTitle: "JPG/JPEG")
        screenshotFormat.addItem(withTitle: "PNG")
    }
    
    // Exits the application.
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self);
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSControlStateValue(_ input: Int) -> NSControl.StateValue {
	return NSControl.StateValue(rawValue: input)
}
