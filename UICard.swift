//
//  UICard.swift
//  CardSimulator2
//
//  Created by Jake Smith on 10/09/2018.
//  Copyright © 2018 Nebultek. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UICard: UIView,UIDynamicAnimatorDelegate {
    
    var animator:UIDynamicAnimator!
    var pan:UIPanGestureRecognizer!
    var attachment:UIAttachmentBehavior!
    var initialCenter: CGPoint!
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var frontText: String = "Front" {
        didSet {
            (viewWithTag(1) as? UILabel)?.text = frontText
        }
    }
    
    @IBInspectable var backText: String = "Back"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = cornerRadius
    }
    
    
    override func awakeFromNib() {
        animator = UIDynamicAnimator(referenceView: self.superview!)
        animator.delegate = self
        initialCenter = self.center
        pan = UIPanGestureRecognizer(target: self, action: #selector(self.panning))
        pan.maximumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
    }
    
    
    @objc func panning(panGesture:UIPanGestureRecognizer)
    {
        let panLocationInView = panGesture.location(in: self.superview!)
        let panLocationInCard = panGesture.location(in: self)
        switch (panGesture.state)
        {
            case UIGestureRecognizerState.began:
                animator.removeAllBehaviors()
                let offset = UIOffsetMake(panLocationInCard.x - self.bounds.midX, panLocationInCard.y - self.bounds.midY);
                attachment = UIAttachmentBehavior(item: self, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                animator.addBehavior(attachment)
            case UIGestureRecognizerState.changed:
                attachment.anchorPoint = panLocationInView
            default:
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
                    self.animator.removeAllBehaviors()
                    self.transform = CGAffineTransform.init(rotationAngle: 0)
                    self.layoutIfNeeded()
                    if self.translatesAutoresizingMaskIntoConstraints == true
                    {
                        self.center = self.initialCenter
                    }
                }, completion: nil)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.transition(with: self, duration: 1, options: [.transitionFlipFromLeft], animations: {
            if let label = self.viewWithTag(1) as? UILabel
            {
                switch(label.text)
                {
                    case self.frontText:
                        label.text = self.backText
                    case self.backText:
                        label.text = self.frontText
                    default:
                        break
                }
            }
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


