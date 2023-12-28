// CBPeripheral+Delegable.swift
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
import CoreBluetooth
import DelegateFoundation

extension Delegable where Base: CBPeripheral {
  public var didUpdateName: AnyPublisher<CBPeripheral, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didUpdateNameRelay
      .eraseToAnyPublisher()
  }

  public var didModifyServices: AnyPublisher<[CBService], Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didModifyServicesRelay
      .eraseToAnyPublisher()
  }

  public var didReadRSSI: AnyPublisher<DidReadRSSIParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didReadRSSIRelay
      .eraseToAnyPublisher()
  }

  public var didDiscoverServices: AnyPublisher<Error?, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didDiscoverServicesRelay
      .eraseToAnyPublisher()
  }

  public var didDiscoverIncludedServices: AnyPublisher<DidDiscoverIncludedServicesParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didDiscoverIncludedServicesRelay
      .eraseToAnyPublisher()
  }

  public var didDiscoverCharacteristics: AnyPublisher<DidDiscoverCharacteristicsParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didDiscoverCharacteristicsRelay
      .eraseToAnyPublisher()
  }

  public var didUpdateValueForCharacteristic: AnyPublisher<DidUpdateValueForCharacteristicParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didUpdateValueForCharacteristicRelay
      .eraseToAnyPublisher()
  }

  public var didWriteValueForCharacteristic: AnyPublisher<DidWriteValueForCharacteristicParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didWriteValueForCharacteristicRelay
      .eraseToAnyPublisher()
  }

  public var didUpdateNotificationState: AnyPublisher<DidUpdateNotificationStateParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didUpdateNotificationStateRelay
      .eraseToAnyPublisher()
  }

  public var didDiscoverDescriptors: AnyPublisher<DidDiscoverDescriptorsParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didDiscoverDescriptorsRelay
      .eraseToAnyPublisher()
  }

  public var didUpdateValueForDescriptor: AnyPublisher<DidUpdateValueForDescriptorParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didUpdateValueForDescriptorRelay
      .eraseToAnyPublisher()
  }

  public var didWriteValueForDescriptor: AnyPublisher<DidWriteValueorDescriptorParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didWriteValueForDescriptorRelay
      .eraseToAnyPublisher()
  }

  public var isReadyToSendWriteWithoutResponse: AnyPublisher<CBPeripheral, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .isReadyToSendWriteWithoutResponseRelay
      .eraseToAnyPublisher()
  }

  public var didOpenChannel: AnyPublisher<DidOpenChannelParam, Never> {
    CBPeripheralDelegateProxy.proxy(for: wrappedValue)
      .didOpenChannelRelay
      .eraseToAnyPublisher()
  }
}

extension CBPeripheral: DelegableCompatible {}
