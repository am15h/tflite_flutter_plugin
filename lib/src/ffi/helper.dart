// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

/// Forces casting a [Pointer] to a different type.
///
/// Unlike [Pointer.cast], the output type does not have to be a subclass of
/// the input type. This is especially useful for with [Pointer<Void>].
Pointer<T> cast<T extends NativeType>(Pointer<NativeType> ptr) =>
    Pointer<T>.fromAddress(ptr.address);

/// Checks if a [Pointer] is not null.
bool isNotNull(Pointer<dynamic> ptr) => ptr.address != nullptr.address;
