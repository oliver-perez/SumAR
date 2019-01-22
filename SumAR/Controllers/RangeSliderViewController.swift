import UIKit

class SecondViewController: UIViewController {
  let upDownSlider = RangeSlider(frame: .zero)
  let rudderSlider = RangeSlider(frame: .zero)
  let engineSlider = RangeSlider(frame: .zero)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(upDownSlider)
    view.addSubview(rudderSlider)
    view.addSubview(engineSlider)

    upDownSlider.addTarget(self, action: #selector(upDownSliderValueChanged(_:)),
                          for: .valueChanged)
    
    rudderSlider.addTarget(self, action: #selector(rudderSliderValueChanged(_:)), for: .valueChanged)
    
     engineSlider.addTarget(self, action: #selector(engineSliderValueChanged(_:)), for: .valueChanged)
    
    let time = DispatchTime.now() + 1
    
    DispatchQueue.main.asyncAfter(deadline: time) {
      self.upDownSlider.trackHighlightTintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
      self.upDownSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
      self.upDownSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
      
      self.rudderSlider.trackHighlightTintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
      self.rudderSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
      self.rudderSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
        
      self.engineSlider.trackHighlightTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
      self.engineSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
      self.engineSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
    
    }
  }
  
  override func viewDidLayoutSubviews() {
    let width: CGFloat = view.frame.width / 10
    let height: CGFloat = view.frame.height / 3
    
    upDownSlider.frame = CGRect(x: 0, y: 0, width: height, height: width)
    upDownSlider.center = CGPoint(x: view.frame.width - 60, y: view.frame.height - height/2 - 20)
    upDownSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    
    engineSlider.frame = CGRect(x: 0, y: 0, width: height, height: width)
    engineSlider.center = CGPoint(x: view.frame.width - 120, y: view.frame.height - height/2 - 20)
    engineSlider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    
    rudderSlider.frame = CGRect(x: 0, y: 0, width: height, height: width)
    rudderSlider.center = CGPoint(x: 60, y: view.frame.height - height/2 - 10)
  }
  
   @objc func engineSliderValueChanged(_ rangeSlider: RangeSlider) {
     let values = "(\(rangeSlider.upperValue))"
     print("Engine slider value changed: \(values)")
  }
   @objc func rudderSliderValueChanged(_ rangeSlider: RangeSlider) {
        let values = "(\(rangeSlider.upperValue))"
        print("Rudder slider value changed: \(values)")
  }
    
   @objc func upDownSliderValueChanged(_ rangeSlider: RangeSlider) {
        let values = "(\(rangeSlider.upperValue))"
        print("Up down slider value changed: \(values)")
  }
}
