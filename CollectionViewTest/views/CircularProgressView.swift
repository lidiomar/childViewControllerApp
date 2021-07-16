import Foundation
import UIKit

class CircularProgressView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var internalCircleLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initializeLayers() {
        let circleRadius = (superview?.frame.size.width ?? 64) / 2.0
        let circularPath = createCircularPath(circleRadius: circleRadius)
        let internalCircularPath = createCircularPath(circleRadius: circleRadius-5)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 4.0
        circleLayer.strokeEnd = 1.0
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 4.0
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        internalCircleLayer.path = internalCircularPath.cgPath
        internalCircleLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(internalCircleLayer)
    }
    
    private func createCircularPath(circleRadius: CGFloat) -> UIBezierPath {
        let point = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        return UIBezierPath(arcCenter: point,
                     radius: circleRadius,
                     startAngle: startPoint,
                     endAngle: endPoint,
                     clockwise: true)
    }
    
    func setupCircularProgressBarLayout(currentValue: Int, maxValue: Int) {
        initializeLayers()
        let progress = progressByCurrentValue(currentValue, and: maxValue)
        
        circleLayer.strokeColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9607843137, alpha: 1)
        circleLayer.fillColor = UIColor.clear.cgColor
        
        progressLayer.strokeColor = #colorLiteral(red: 0.8941176471, green: 0.05098039216, blue: 0.3568627451, alpha: 1)
        progressLayer.fillColor = UIColor.clear.cgColor
        
        if progress == 0 {
            internalCircleLayer.fillColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9607843137, alpha: 1)
        } else {
            internalCircleLayer.fillColor = #colorLiteral(red: 0.8941176471, green: 0.05098039216, blue: 0.3568627451, alpha: 1)
        }
        setProgress(progress: progress)
    }
    
    private func progressByCurrentValue(_ currentValue: Int, and maxValue: Int) -> Double {
        return Double(currentValue) / Double(maxValue)
    }
    
    private func setProgress(progress: Double) {
        progressLayer.strokeEnd = CGFloat(progress)
    }
}
