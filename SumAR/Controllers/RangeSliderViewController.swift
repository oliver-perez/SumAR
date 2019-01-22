import UIKit

class SecondViewController: UIViewController {
  let rangeSlider = RangeSlider(frame: .zero)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(rangeSlider)
    rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                          for: .valueChanged)
    let time = DispatchTime.now() + 1
    let width = view.bounds.width / 2
    let margin: CGFloat = 30
    let height: CGFloat = 60
    
    DispatchQueue.main.asyncAfter(deadline: time) {
      self.rangeSlider.trackHighlightTintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
      self.rangeSlider.thumbImage = #imageLiteral(resourceName: "RectThumb")
      self.rangeSlider.highlightedThumbImage = #imageLiteral(resourceName: "HighlightedRect")
        self.rangeSlider.transform = self.rangeSlider.transform.rotated(by: CGFloat(-Float.pi/2))
  
        
        self.rangeSlider.frame = CGRect(x: 0, y: 0,
                                   width: height, height: width - margin)
        self.rangeSlider.center = self.view.center

    }
  }
  
  override func viewDidLayoutSubviews() {
    
  }
  
  @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
    let values = "(\(rangeSlider.upperValue))"
    print("Range slider value changed: \(values)")
  }
}
