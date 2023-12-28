// CBPeripheralDelegateProxy.swift
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

public typealias DidReadRSSIParam = (RSSI: NSNumber, error: Error?)
public typealias DidDiscoverIncludedServicesParam = (service: CBService, error: Error?)
public typealias DidDiscoverCharacteristicsParam = (service: CBService, error: Error?)
public typealias DidUpdateValueForCharacteristicParam = (characteristic: CBCharacteristic, error: Error?)
public typealias DidWriteValueForCharacteristicParam = (characteristic: CBCharacteristic, error: Error?)
public typealias DidUpdateNotificationStateParam = (characteristic: CBCharacteristic, error: Error?)
public typealias DidDiscoverDescriptorsParam = (characteristic: CBCharacteristic, error: Error?)
public typealias DidUpdateValueForDescriptorParam = (descriptor: CBDescriptor, error: Error?)
public typealias DidWriteValueorDescriptorParam = (descriptor: CBDescriptor, error: Error?)
public typealias DidOpenChannelParam = (channel: CBL2CAPChannel?, error: Error?)

final class CBPeripheralDelegateProxy: DelegateProxy<CBPeripheral, CBPeripheralDelegate>, DelegateProxyProtocol {
  static func createProxy(for object: CBPeripheral) -> CBPeripheralDelegateProxy {
    CBPeripheralDelegateProxy(object: object, delegateProxyType: CBPeripheralDelegateProxy.self)
  }

  static func setProxyDelegate(_ object: CBPeripheral, to proxy: CBPeripheralDelegateProxy) {
    object.delegate = proxy
  }

  static func forwardToDelegate(for object: CBPeripheral) -> CBPeripheralDelegate? {
    object.delegate
  }

  let didUpdateNameRelay = PassthroughSubject<CBPeripheral, Never>()
  let didModifyServicesRelay = PassthroughSubject<[CBService], Never>()
  let didReadRSSIRelay = PassthroughSubject<DidReadRSSIParam, Never>()
  let didDiscoverServicesRelay = PassthroughSubject<Error?, Never>()
  let didDiscoverIncludedServicesRelay = PassthroughSubject<DidDiscoverIncludedServicesParam, Never>()
  let didDiscoverCharacteristicsRelay = PassthroughSubject<DidDiscoverCharacteristicsParam, Never>()
  let didUpdateValueForCharacteristicRelay = PassthroughSubject<DidUpdateValueForCharacteristicParam, Never>()
  let didWriteValueForCharacteristicRelay = PassthroughSubject<DidWriteValueForCharacteristicParam, Never>()
  let didUpdateNotificationStateRelay = PassthroughSubject<DidUpdateNotificationStateParam, Never>()
  let didDiscoverDescriptorsRelay = PassthroughSubject<DidDiscoverDescriptorsParam, Never>()
  let didUpdateValueForDescriptorRelay = PassthroughSubject<DidUpdateValueForDescriptorParam, Never>()
  let didWriteValueForDescriptorRelay = PassthroughSubject<DidWriteValueorDescriptorParam, Never>()
  let isReadyToSendWriteWithoutResponseRelay = PassthroughSubject<CBPeripheral, Never>()
  let didOpenChannelRelay = PassthroughSubject<DidOpenChannelParam, Never>()
}

extension CBPeripheralDelegateProxy: CBPeripheralDelegate {
  /**
   *  @method peripheralDidUpdateName:
   *
   *  @param peripheral  The peripheral providing this update.
   *
   *  @discussion      This method is invoked when the @link name @/link of <i>peripheral</i> changes.
   */
  func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
    didUpdateNameRelay.send(peripheral)
    forwardToDelegate?.peripheralDidUpdateName?(peripheral)
  }

  /**
   *  @method peripheral:didModifyServices:
   *
   *  @param peripheral      The peripheral providing this update.
   *  @param invalidatedServices  The services that have been invalidated
   *
   *  @discussion      This method is invoked when the @link services @/link of <i>peripheral</i> have been changed.
   *            At this point, the designated <code>CBService</code> objects have been invalidated.
   *            Services can be re-discovered via @link discoverServices: @/link.
   */
  func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    didModifyServicesRelay.send(invalidatedServices)
    forwardToDelegate?.peripheral?(peripheral, didModifyServices: invalidatedServices)
  }

  /**
   *  @method peripheral:didReadRSSI:error:
   *
   *  @param peripheral  The peripheral providing this update.
   *  @param RSSI      The current RSSI of the link.
   *  @param error    If an error occurred, the cause of the failure.
   *
   *  @discussion      This method returns the result of a @link readRSSI: @/link call.
   */
  func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    didReadRSSIRelay.send((RSSI, error))
    forwardToDelegate?.peripheral?(peripheral, didReadRSSI: RSSI, error: error)
  }

  /**
   *  @method peripheral:didDiscoverServices:
   *
   *  @param peripheral  The peripheral providing this information.
   *  @param error    If an error occurred, the cause of the failure.
   *
   *  @discussion      This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
   *            <i>peripheral</i>'s @link services @/link property.
   *
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    didDiscoverServicesRelay.send(error)
    forwardToDelegate?.peripheral?(peripheral, didDiscoverServices: error)
  }

  /**
   *  @method peripheral:didDiscoverIncludedServicesForService:error:
   *
   *  @param peripheral  The peripheral providing this information.
   *  @param service    The <code>CBService</code> object containing the included services.
   *  @param error    If an error occurred, the cause of the failure.
   *
   *  @discussion      This method returns the result of a @link discoverIncludedServices:forService: @/link call. If the included service(s) were read successfully,
   *            they can be retrieved via <i>service</i>'s <code>includedServices</code> property.
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
    didDiscoverIncludedServicesRelay.send((service, error))
    forwardToDelegate?.peripheral?(peripheral, didDiscoverIncludedServicesFor: service, error: error)
  }

  /**
   *  @method peripheral:didDiscoverCharacteristicsForService:error:
   *
   *  @param peripheral  The peripheral providing this information.
   *  @param service    The <code>CBService</code> object containing the characteristic(s).
   *  @param error    If an error occurred, the cause of the failure.
   *
   *  @discussion      This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
   *            they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    didDiscoverCharacteristicsRelay.send((service, error))
    forwardToDelegate?.peripheral?(peripheral, didDiscoverCharacteristicsFor: service, error: error)
  }

  /**
   *  @method peripheral:didUpdateValueForCharacteristic:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param characteristic  A <code>CBCharacteristic</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
   */
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    didUpdateValueForCharacteristicRelay.send((characteristic, error))
    forwardToDelegate?.peripheral?(peripheral, didUpdateValueFor: characteristic, error: error)
  }

  /**
   *  @method peripheral:didWriteValueForCharacteristic:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param characteristic  A <code>CBCharacteristic</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
   */
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    didWriteValueForCharacteristicRelay.send((characteristic, error))
    forwardToDelegate?.peripheral?(peripheral, didWriteValueFor: characteristic, error: error)
  }

  /**
   *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param characteristic  A <code>CBCharacteristic</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
   */
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    didUpdateNotificationStateRelay.send((characteristic, error))
    forwardToDelegate?.peripheral?(peripheral, didUpdateNotificationStateFor: characteristic, error: error)
  }

  /**
   *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param characteristic  A <code>CBCharacteristic</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
   *              they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
   */
  func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
    didDiscoverDescriptorsRelay.send((characteristic, error))
    forwardToDelegate?.peripheral?(peripheral, didDiscoverDescriptorsFor: characteristic, error: error)
  }

  /**
   *  @method peripheral:didUpdateValueForDescriptor:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param descriptor    A <code>CBDescriptor</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method returns the result of a @link readValueForDescriptor: @/link call.
   */
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
    didUpdateValueForDescriptorRelay.send((descriptor, error))
    forwardToDelegate?.peripheral?(peripheral, didUpdateValueFor: descriptor, error: error)
  }

  /**
   *  @method peripheral:didWriteValueForDescriptor:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param descriptor    A <code>CBDescriptor</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method returns the result of a @link writeValue:forDescriptor: @/link call.
   */
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
    didWriteValueForDescriptorRelay.send((descriptor, error))
    forwardToDelegate?.peripheral?(peripheral, didWriteValueFor: descriptor, error: error)
  }

  /**
   *  @method peripheralIsReadyToSendWriteWithoutResponse:
   *
   *  @param peripheral   The peripheral providing this update.
   *
   *  @discussion         This method is invoked after a failed call to @link writeValue:forCharacteristic:type: @/link, when <i>peripheral</i> is again
   *                      ready to send characteristic value updates.
   *
   */
  func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
    isReadyToSendWriteWithoutResponseRelay.send(peripheral)
    forwardToDelegate?.peripheralIsReady?(toSendWriteWithoutResponse: peripheral)
  }

  /**
   *  @method peripheral:didOpenL2CAPChannel:error:
   *
   *  @param peripheral    The peripheral providing this information.
   *  @param channel      A <code>CBL2CAPChannel</code> object.
   *  @param error      If an error occurred, the cause of the failure.
   *
   *  @discussion        This method returns the result of a @link openL2CAPChannel: @link call.
   */
  func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
    didOpenChannelRelay.send((channel, error))
    forwardToDelegate?.peripheral?(peripheral, didOpen: channel, error: error)
  }
}
