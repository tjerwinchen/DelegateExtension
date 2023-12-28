// PKPaymentAuthorizationController+Delegable.swift
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
import PassKit

extension Delegable where Base: PKPaymentAuthorizationController {
  public var didFinish: AnyPublisher<Void, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didFinishRelay
      .eraseToAnyPublisher()
  }

  public var willAuthorizePayment: AnyPublisher<Void, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .willAuthorizePaymentRelay
      .eraseToAnyPublisher()
  }

  public var didAuthorizePayment: AnyPublisher<DidAuthorizePaymentRelayParam, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didAuthorizePaymentRelay
      .eraseToAnyPublisher()
  }

  public var didRequestMerchantSessionUpdate: AnyPublisher<DidRequestMerchantSessionUpdateRelayParam, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didRequestMerchantSessionUpdateRelay
      .eraseToAnyPublisher()
  }

  @available(iOS 15.0, *)
  public var didChangeCouponCode: AnyPublisher<DidChangeCouponCodeRelayParam, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didChangeCouponCodeRelay
      .eraseToAnyPublisher()
  }

  public var didSelectShippingMethodRelay: AnyPublisher<DidSelectShippingMethodRelayParam, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didSelectShippingMethodRelay
      .eraseToAnyPublisher()
  }

  public var didSelectShippingContactRelay: AnyPublisher<DidSelectShippingContactRelayParam, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didSelectShippingContactRelay
      .eraseToAnyPublisher()
  }

  public var didSelectPaymentMethodRelay: AnyPublisher<DidSelectPaymentMethodRelayParam, Never> {
    PKPaymentAuthorizationControllerDelegateProxy.proxy(for: wrappedValue)
      .didSelectPaymentMethodRelay
      .eraseToAnyPublisher()
  }
}

extension PKPaymentAuthorizationController: DelegableCompatible {}
