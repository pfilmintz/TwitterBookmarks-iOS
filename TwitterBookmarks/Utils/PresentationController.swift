//
//  PresentationController.swift
//  Minztership
//
//  Created by mac on 31/05/2022.
//

import UIKit

class PresentationController: UIPresentationController {

  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .dark)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }
 
   /* override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        guard let containerView = containerView else {
            return
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            containerView.setNeedsLayout()
            containerView.layoutIfNeeded()
        })
    }*/
    
  override var frameOfPresentedViewInContainerView: CGRect {
      
     
      
    /*  CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.6))*/
      
      guard let containerView = containerView,
                  let presentedView = presentedView else { return .zero }

              let inset: CGFloat = 8

              // Make sure to account for the safe area insets
              let safeAreaFrame = containerView.bounds
                  .inset(by: containerView.safeAreaInsets)

              let targetWidth = safeAreaFrame.width - 2 * inset
              let fittingSize = CGSize(
                  width: targetWidth,
                  height: UIView.layoutFittingCompressedSize.height
              )
              let targetHeight = presentedView.systemLayoutSizeFitting(
                  fittingSize, withHorizontalFittingPriority: .required,
                  verticalFittingPriority: .defaultLow).height

              var frame = safeAreaFrame
              frame.origin.x += inset
              frame.origin.y += frame.size.height - targetHeight - inset
              frame.size.width = targetWidth
              frame.size.height = targetHeight
              return frame

       
      
      
   
  }
    

  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.7
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
  }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}
