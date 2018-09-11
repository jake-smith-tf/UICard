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
class UICard: UIView {
    
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
        initialCenter = self.center
        pan = UIPanGestureRecognizer(target: self, action: #selector(self.panning))
        self.addGestureRecognizer(pan)
    }
    
    
    @objc func panning(panGesture:UIPanGestureRecognizer)
    {
        let panLocationInView = panGesture.location(in: self.superview!)
        let panLocationInCard = panGesture.location(in: self)
        
        if panGesture.state == UIGestureRecognizerState.began {
            animator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInCard.x - self.bounds.midX, panLocationInCard.y - self.bounds.midY);
            attachment = UIAttachmentBehavior(item: self, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            animator.addBehavior(attachment)
        }
        
        if panGesture.state == UIGestureRecognizerState.ended {
           //animator.addBehavior(snap)
            animator.removeAllBehaviors()
            let snapBehavior = UISnapBehavior(item: self, snapTo: initialCenter)
            animator.addBehavior(snapBehavior)
            
        }
        
        if panGesture.state == UIGestureRecognizerState.changed {
            attachment.anchorPoint = panLocationInView
        } else {
            // or something when its not moving
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


