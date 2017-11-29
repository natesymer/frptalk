//
//  Signal.swift
//
//  Created by Nate Symer on 11/7/17.
//  Copyright © 2017 Nate Symer. All rights reserved.
//

import Foundation

class Signal<T> {
    internal var subscribers: [(T) -> Void] = [];
    internal var _value: T? = nil;
    
    func subscribe(f: @escaping (T) -> Void) {
        subscribers.append(f);
    }
    
    func update(value: T) {
        _value = value;
        subscribers.forEach { sbc in
            sbc(value);
        }
    }
    
    func map<TT>(f: @escaping (T) -> (TT)) -> Signal<TT> {
        let s: Signal<TT> = Signal<TT>();
        self.subscribe { v in
            s.update(value: f(v));
        }
        return s;
    }
    
    func filter(p: @escaping (T) -> Bool) -> Signal<T> {
        let s: Signal<T> = Signal<T>();
        self.subscribe { v in
            if (p(v)) {
                s.update(value: v);
            }
        }
        return s;
    }
}

func signalReduce<T, Result>(f: @escaping (Result, T) -> Result,
                             initial: Result,
                             signals: [Signal<T>])
                             -> Signal<Result> {
        let newSig: Signal<Result> = Signal<Result>();
        signals.forEach { sig in
            sig.subscribe(f: { _ in
                newSig.update(value: signals.map({ $0._value! }).reduce(initial, f))
            });
        };
        return newSig;
}
