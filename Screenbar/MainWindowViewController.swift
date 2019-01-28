import Cocoa

class MainWindowViewController: NSViewController {
    
    @IBOutlet weak var CaptureScreenshot: NSButton!
    @IBOutlet weak var secondsTextBox: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var path: NSPathControl!
    @IBOutlet weak var screenshotFormat: NSPopUpButton!
    @IBOutlet weak var playSound: NSButton!
    @IBOutlet weak var quit: NSButton!
    
    
    var timer: Timer = Timer()
    let screenshotHandler = ScreenShot()
    
    override func viewDidLoad() {
        self.setFormat()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setSeconds()
        self.hideError()
        self.setPath()
        self.setPlaySound()
    }
    
    
    func saveSettings(_ seconds: Double?, path: URL?, playSound: Int) {
        Settings.setSecondsIntervall(seconds)
        Settings.setPath(path)
        Settings.setPlaySound(playSound)
    }
    
    func saveSettings() -> Bool {
        var success = true;

        let seconds: Double? = Double(self.secondsTextBox.stringValue)
        let path: URL? = self.path.url
        let playSound = self.playSound.state
        
        if(seconds == nil) {
            self.showError()
            success = false;
        }
        else {
            self.hideError()
            self.saveSettings(seconds, path: path, playSound: playSound.rawValue)
        }
        return success;
    }
    
    @IBAction func CaptureScreenshots(_ sender: Any) {
        if(self.saveSettings()) {
            self.automaticScreenshot()
        }
    }
    
    func automaticScreenshot() {
        if(self.timer.isValid) {
            self.stopAutomaticScreenShot()
        }
        else {
            self.startAutomaticScreenshot()
        }
    }
    
    func ChangeTitleOfButton(_ title:String) {
        self.CaptureScreenshot.title = title
    }
    
    func stopAutomaticScreenShot() {
        self.timer.invalidate()
        self.ChangeTitleOfButton("Capture automatic screenshot")
    }
    
    func startAutomaticScreenshot() {
        let seconds = Settings.getSecondsInterval()
        
        let item = screenshotFormat.indexOfSelectedItem
        
        self.timer = Timer.scheduledTimer(timeInterval: seconds!, target: screenshotHandler, selector: #selector(ScreenShot.TakeScreenshot(timer:)), userInfo: item, repeats: true)
        self.ChangeTitleOfButton("Stop automatic screenshot")
    }
    
    func setSeconds() {
        let seconds: Double? = Settings.getSecondsInterval()
        self.secondsTextBox.stringValue = String(seconds!)
    }
    
    func setPlaySound() {
        self.playSound.state = convertToNSControlStateValue(Settings.getPlaySound())
    }
    
    func showError() {
        self.errorMessage.isHidden = false
    }
    
    func hideError() {
        self.errorMessage.isHidden = true
    }
    
    func setPath() {
        self.path.url = Settings.getPath() as URL
        self.path.allowedTypes = nil
    }
    
    func close() {
        let appDelegate : AppDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hideMainWindow(self)
    }
    
    func setFormat(){
        screenshotFormat.removeAllItems()
        let formatSelections = ["JPG/JPEG","PNG"]
        screenshotFormat.addItems(withTitles: formatSelections)
        screenshotFormat.selectItem(at: 0)
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self);
    }
}

fileprivate func convertToNSControlStateValue(_ input: Int) -> NSControl.StateValue {
	return NSControl.StateValue(rawValue: input)
}
