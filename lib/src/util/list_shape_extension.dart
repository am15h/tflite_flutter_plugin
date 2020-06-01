extension ListShape on List {
  List reshape<T>(List<int> shape) {
    var dims = shape.length;
    var numElements = 1;
    for (var i = 0; i < dims; i++) {
      numElements *= shape[i];
    }

    if (numElements != computeNumElements) {
      throw ArgumentError(
          'Total elements mismatch expected: $numElements elements for shape: $shape but found $computeNumElements');
    }

    if (dims <= 5) {
      switch (dims) {
        case 2:
          return this.reshape2<T>(shape);
        case 3:
          return this.reshape3<T>(shape);
        case 4:
          return this.reshape4<T>(shape);
        case 5:
          return this.reshape5<T>(shape);
      }
    }

    var reshapedList = flatten<dynamic>();
    for (var i = dims - 1; i > 0; i--) {
      var temp = [];
      for (var start = 0;
          start + shape[i] <= reshapedList.length;
          start += shape[i]) {
        temp.add(reshapedList.sublist(start, start + shape[i]));
      }
      reshapedList = temp;
    }
    return reshapedList;
  }

  List<List<T>> reshape2<T>(List<int> shape) {
    if (shape.length != 2) {
      if (shape.length <= 5) {
        throw ArgumentError(
            'Use the extension reshape${shape.length} instead of reshape2');
      } else {
        throw ArgumentError('Use the extension reshape instead of reshape2');
      }
    }

    var dims = shape.length;
    var numElements = 1;
    for (var i = 0; i < dims; i++) {
      numElements *= shape[i];
    }

    if (numElements != computeNumElements) {
      throw ArgumentError(
          'Total elements mismatch expected: $numElements elements for shape: $shape but found $computeNumElements');
    }
    var flatList = flatten<T>();
    List<List<T>> reshapedList = List.generate(
      shape[0],
      (i) => List.generate(
        shape[1],
        (j) => flatList[i * shape[1] + j],
      ),
    );

    return reshapedList;
  }

  List<List<List<T>>> reshape3<T>(List<int> shape) {
    if (shape.length != 3) {
      if (shape.length <= 5) {
        throw ArgumentError(
            'Use the extension reshape${shape.length} instead of reshape3');
      } else {
        throw ArgumentError('Use the extension reshape instead of reshape3');
      }
    }

    var dims = shape.length;
    var numElements = 1;
    for (var i = 0; i < dims; i++) {
      numElements *= shape[i];
    }

    if (numElements != computeNumElements) {
      throw ArgumentError(
          'Total elements mismatch expected: $numElements elements for shape: $shape but found $computeNumElements');
    }
    var flatList = flatten<T>();
    List<List<List<T>>> reshapedList = List.generate(
      shape[0],
      (i) => List.generate(
        shape[1],
        (j) => List.generate(
          shape[2],
          (k) => flatList[i * shape[1] * shape[2] + j * shape[2] + k],
        ),
      ),
    );

    return reshapedList;
  }

  List<List<List<List<T>>>> reshape4<T>(List<int> shape) {
    if (shape.length != 4) {
      if (shape.length <= 5) {
        throw ArgumentError(
            'Use the extension reshape${shape.length} instead of reshape4');
      } else {
        throw ArgumentError('Use the extension reshape instead of reshape4');
      }
    }

    var dims = shape.length;
    var numElements = 1;
    for (var i = 0; i < dims; i++) {
      numElements *= shape[i];
    }

    if (numElements != computeNumElements) {
      throw ArgumentError(
          'Total elements mismatch expected: $numElements elements for shape: $shape but found $computeNumElements');
    }
    var flatList = this.flatten<T>();
    print('aaa ${flatList.shape}');

    List<List<List<List<T>>>> reshapedList = List.generate(
      shape[0],
      (i) => List.generate(
        shape[1],
        (j) => List.generate(
          shape[2],
          (k) => List.generate(
            shape[3],
            (l) => flatList[i * shape[1] * shape[2] * shape[3] +
                j * shape[2] * shape[3] +
                k * shape[3] +
                l],
          ),
        ),
      ),
    );

    return reshapedList;
  }

  List<List<List<List<List<T>>>>> reshape5<T>(List<int> shape) {
    if (shape.length != 5) {
      if (shape.length <= 5) {
        throw ArgumentError(
            'Use the extension reshape${shape.length} instead of reshape5');
      } else {
        throw ArgumentError('Use the extension reshape instead of reshape5');
      }
    }

    var dims = shape.length;
    var numElements = 1;
    for (var i = 0; i < dims; i++) {
      numElements *= shape[i];
    }

    if (numElements != computeNumElements) {
      throw ArgumentError(
          'Total elements mismatch expected: $numElements elements for shape: $shape but found $computeNumElements');
    }
    var flatList = flatten<T>();
    List<List<List<List<List<T>>>>> reshapedList = List.generate(
      shape[0],
      (i) => List.generate(
        shape[1],
        (j) => List.generate(
          shape[2],
          (k) => List.generate(
            shape[3],
            (l) => List.generate(
              shape[4],
              (m) => flatList[i * shape[1] * shape[2] * shape[3] * shape[4] +
                  j * shape[2] * shape[3] * shape[4] +
                  k * shape[3] * shape[4] +
                  l * shape[4] +
                  m],
            ),
          ),
        ),
      ),
    );

    return reshapedList;
  }

  List<int> get shape {
    if (isEmpty) {
      return [];
    }
    var list = this as dynamic;
    var shape = <int>[];
    while (list is List) {
      shape.add((list as List).length);
      list = list.elementAt(0);
    }
    return shape;
  }

  List<T> flatten<T>() {
    var flat = <T>[];
    forEach((e) {
      if (e is List) {
        flat.addAll(e.flatten());
      } else if (e is T) {
        flat.add(e);
      } else {
        // Error with typing
      }
    });
    return flat;
  }

  int get computeNumElements {
    var n = 1;
    for (var i = 0; i < shape.length; i++) {
      n *= shape[i];
    }
    return n;
  }
}
