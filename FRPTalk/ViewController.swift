//
//  ViewController.swift
//  FRPTalk
//
//  Created by Nate Symer on 11/7/17.
//  Copyright © 2017 Nate Symer. All rights reserved.
//

import UIKit

class SignalTextField : UITextField {
    /* LOOK HERE */
    public var textSignal: Signal<String> = Signal<String>();
    /* */
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        /* LOOK HERE */
        textSignal.subscribe { str in
            self.text = str;
        }
        /**/
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChangeAction(_:)), name: .UITextFieldTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChangeAction(_ notification: NSNotification) {
        let textField = notification.object as! UITextField;
        /*
         LOOK HERE!!!!!!!!!!
         */
        textSignal.update(value: textField.text!);
        /*
        */
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        let sz = UIScreen.main.bounds.size;
        let w: CGFloat = sz.width * (3/4);
        let h: CGFloat = 44;
        let tf = SignalTextField(frame: CGRect(origin: CGPoint(x: (sz.width - w)/2, y: (sz.height - h)/2),
                                               size: CGSize(width: w, height: h)));
        tf.placeholder = "Enter some text";
        self.view.addSubview(tf);
        
        /*
         LOOK HERE!!!!!!!!!!
        */
        tf.textSignal.map { $0.uppercased() }
                     .filter(p: { $0.characters.count > 4 })
                     .subscribe { (str) in
            print("Uppercased string where len(str) > 4: ", str);
        }
        /*
        */
    }
}

