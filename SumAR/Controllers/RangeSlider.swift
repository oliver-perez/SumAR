import UIKit

class RangeSlider: UIControl {
  override var frame: CGRect {
    didSet {
      updateLayerFrames()
    }
  }
  
  var maximumValue: CGFloat = 1 {
    didSet {
      updateLayerFrames()
    }
  }

  var upperValue: CGFloat = 0.5 {
    didSet {
      updateLayerFrames()
    }
  }
  
  var trackTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  var thumbImage = #imageLiteral(resourceName: "RectThumb") {
    didSet {
      upperThumbImageView.image = thumbImage
      updateLayerFrames()
    }
  }
  
  var highlightedThumbImage = #imageLiteral(resourceName: "RectThumb") {
    didSet {
      upperThumbImageView.highlightedImage = highlightedThumbImage
      updateLayerFrames()
    }
  }
  
  
  private let trackLayer = RangeSliderTrackLayer()
  private let upperThumbImageView = UIImageView()
  private var previousLocation = CGPoint()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    trackLayer.rangeSlider = self
    trackLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(trackLayer)

    upperThumbImageView.image = thumbImage
    addSubview(upperThumbImageView)
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 1
  private func updateLayerFrames() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)

    trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
    trackLayer.setNeedsDisplay()
    
    upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                       size: thumbImage.size)
    CATransaction.commit()
  }
  // 2
  func positionForValue(_ value: CGFloat) -> CGFloat {
    return bounds.width * value
  }
  // 3
  private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
    let x = positionForValue(value) - thumbImage.size.width / 2.0
    return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
  }
}

extension RangeSlider {
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    // 1
    previousLocation = touch.location(in: self)
    
    if upperThumbImageView.frame.contains(previousLocation) {
      upperThumbImageView.isHighlighted = true
    }
    
    // 3
    return  upperThumbImageView.isHighlighted
  }
  
  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)
    
    // 1
    let deltaLocation = location.x - previousLocation.x
    let deltaValue = maximumValue * deltaLocation / bounds.width
    
    previousLocation = location
    
    if upperThumbImageView.isHighlighted {
      upperValue += deltaValue
      upperValue = boundValue(upperValue, toLowerValue: 0,
                              upperValue: maximumValue)
    }
    
    sendActions(for: .valueChanged)
    return true
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    upperThumbImageView.isHighlighted = false
  }
  
  // 4
  private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
    return min(max(value, lowerValue), upperValue)
  }
}
