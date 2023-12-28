// PKPaymentAuthorizationControllerDelegateProxy.swift
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

public typealias DidAuthorizePaymentRelayParam = (payment: PKPayment, completion: (PKPaymentAuthorizationResult) -> Void)
public typealias DidRequestMerchantSessionUpdateRelayParam = (PKPaymentRequestMerchantSessionUpdate) -> Void

@available(iOS 15.0, *)
public typealias DidChangeCouponCodeRelayParam = (couponCode: String, completion: (PKPaymentRequestCouponCodeUpdate) -> Void)

public typealias DidSelectShippingMethodRelayParam = (shippingMethod: PKShippingMethod, completion: (PKPaymentRequestShippingMethodUpdate) -> Void)
public typealias DidSelectShippingContactRelayParam = (contact: PKContact, completion: (PKPaymentRequestShippingContactUpdate) -> Void)
public typealias DidSelectPaymentMethodRelayParam = (paymentMethod: PKPaymentMethod, completion: (PKPaymentRequestPaymentMethodUpdate) -> Void)

final class PKPaymentAuthorizationControllerDelegateProxy: DelegateProxy<PKPaymentAuthorizationController, PKPaymentAuthorizationControllerDelegate>, DelegateProxyProtocol {
  static func createProxy(for object: PKPaymentAuthorizationController) -> PKPaymentAuthorizationControllerDelegateProxy {
    PKPaymentAuthorizationControllerDelegateProxy(object: object, delegateProxyType: PKPaymentAuthorizationControllerDelegateProxy.self)
  }

  static func setProxyDelegate(_ object: PKPaymentAuthorizationController, to proxy: PKPaymentAuthorizationControllerDelegateProxy) {
    object.delegate = proxy
  }

  static func forwardToDelegate(for object: PKPaymentAuthorizationController) -> PKPaymentAuthorizationControllerDelegate? {
    object.delegate
  }

  public let didFinishRelay = PassthroughSubject<Void, Never>()
  public let didAuthorizePaymentRelay = PassthroughSubject<DidAuthorizePaymentRelayParam, Never>()
  public let willAuthorizePaymentRelay = PassthroughSubject<Void, Never>()
  public let didRequestMerchantSessionUpdateRelay = PassthroughSubject<DidRequestMerchantSessionUpdateRelayParam, Never>()

  private var _didChangeCouponCodeRelay: Any?

  @available(iOS 15.0, *)
  public var didChangeCouponCodeRelay: PassthroughSubject<DidChangeCouponCodeRelayParam, Never> {
    if _didChangeCouponCodeRelay == nil {
      _didChangeCouponCodeRelay = PassthroughSubject<DidChangeCouponCodeRelayParam, Never>()
    }

    return _didChangeCouponCodeRelay as! PassthroughSubject<DidChangeCouponCodeRelayParam, Never>
  }

  public let didSelectShippingMethodRelay = PassthroughSubject<DidSelectShippingMethodRelayParam, Never>()
  public let didSelectShippingContactRelay = PassthroughSubject<DidSelectShippingContactRelayParam, Never>()
  public let didSelectPaymentMethodRelay = PassthroughSubject<DidSelectPaymentMethodRelayParam, Never>()
}

extension PKPaymentAuthorizationControllerDelegateProxy: PKPaymentAuthorizationControllerDelegate {
  @MainActor func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    didFinishRelay.send()

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationControllerDidFinish(controller)
    }
  }

  @MainActor func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    didAuthorizePaymentRelay.send((payment, completion))

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationController?(controller, didAuthorizePayment: payment, handler: completion)
    }
  }

  @MainActor func paymentAuthorizationControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationController) {
    willAuthorizePaymentRelay.send()

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationControllerWillAuthorizePayment?(controller)
    }
  }

  @MainActor func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didRequestMerchantSessionUpdate handler: @escaping (PKPaymentRequestMerchantSessionUpdate) -> Void) {
    didRequestMerchantSessionUpdateRelay.send(handler)

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationController?(controller, didRequestMerchantSessionUpdate: handler)
    }
  }

  @available(iOS 15.0, *)
  @MainActor func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didChangeCouponCode couponCode: String, handler completion: @escaping (PKPaymentRequestCouponCodeUpdate) -> Void) {
    didChangeCouponCodeRelay.send((couponCode, completion))

    forwardToDelegate?.paymentAuthorizationController?(controller, didChangeCouponCode: couponCode, handler: completion)
  }

  // Sent when the user has selected a new shipping method.  The delegate should determine
  // shipping costs based on the shipping method and either the shipping address contact in the original
  // PKPaymentRequest or the contact provided by the last call to paymentAuthorizationController:
  // didSelectShippingContact:completion:.
  //
  // The delegate must invoke the completion block with an updated array of PKPaymentSummaryItem objects.
  //
  // The delegate will receive no further callbacks except paymentAuthorizationControllerDidFinish:
  // until it has invoked the completion block.
  @MainActor func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingMethod shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
    didSelectShippingMethodRelay.send((shippingMethod, completion))

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationController?(controller, didSelectShippingMethod: shippingMethod, handler: completion)
    }
  }

  @MainActor func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {
    didSelectShippingContactRelay.send((contact, completion))

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationController?(controller, didSelectShippingContact: contact, handler: completion)
    }
  }

  // Sent when the user has selected a new payment card.  Use this delegate callback if you need to
  // update the summary items in response to the card type changing (for example, applying credit card surcharges)
  //
  // The delegate will receive no further callbacks except paymentAuthorizationControllerDidFinish:
  // until it has invoked the completion block.
  @MainActor func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
    didSelectPaymentMethodRelay.send((paymentMethod, completion))

    if #available(iOS 14.0, *) {
      forwardToDelegate?.paymentAuthorizationController?(controller, didSelectPaymentMethod: paymentMethod, handler: completion)
    }
  }
}
