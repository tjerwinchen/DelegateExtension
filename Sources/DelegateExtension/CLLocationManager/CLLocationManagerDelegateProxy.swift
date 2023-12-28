// CLLocationManagerDelegateProxy.swift
//
// Copyright (c) 2023 Codebase.Codes
// Created by Theo Chen on 2023.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Combine
import CoreLocation
import DelegateFoundation

final class CLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyProtocol {
  static func createProxy(for object: CLLocationManager) -> CLLocationManagerDelegateProxy {
    CLLocationManagerDelegateProxy(object: object, delegateProxyType: CLLocationManagerDelegateProxy.self)
  }

  static func setProxyDelegate(_ object: CLLocationManager, to proxy: CLLocationManagerDelegateProxy) {
    object.delegate = proxy
  }

  static func forwardToDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
    object.delegate
  }

  public let didChangeAuthorizationRelay = PassthroughSubject<Void, Never>()
}

extension CLLocationManagerDelegateProxy: CLLocationManagerDelegate {
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    didChangeAuthorizationRelay.send()
    if #available(iOS 14.0, *) {
      forwardToDelegate?.locationManagerDidChangeAuthorization?(manager)
    }
  }
}
