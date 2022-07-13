//
//  Observable.swift
//  TwitterBookmarks
//
//  Created by mac on 12/07/2022.
//

import Foundation

public final class TweetsObservableObject<T> {

    //one person subscri to notificaton
    private var listener: ((T) -> ())?

    public var value: T {
        didSet {
            listener?(value)
            
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value)
    }
}

public final class ImagesObservableObject<T> {

    //one person subscri to notificaton
    private var listener: ((T) -> ())?

    public var value: T {
        didSet {
            listener?(value)
            
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(value)
    }
}
