import 'json_lib_exception.dart';

Type _typeOf<T>() => T;

String _formatValueNotFoundMessage(List<dynamic> path) {
  String errorMessage;
  if (path.length > 1) {
    errorMessage =
        'Value at path $path is not found. Use "try" prefixed version of the function if value could be missing';
  } else if (path.length == 1) {
    if (path.first is int) {
      errorMessage =
          'Value at index ${path.first} is not found or index is out of bounds. Use "try" prefixed version of the function if value could be missing';
    } else {
      errorMessage =
          'Value "${path.first}" is not found. Use "try" prefixed version of the function if value could be missing';
    }
  } else {
    errorMessage = 'Value is not found. Use "try" prefixed version of the function if value could be missing';
  }

  return errorMessage;
}

String _formatTypeMismatchMessage<T>(List<dynamic> path, dynamic value, bool hasTypeConverter) {
  String nameMessage;

  if (path.length > 1) {
    nameMessage = 'Value at path $path';
  } else if (path.length == 1) {
    nameMessage = path.first is int ? 'List item at index ${path.first}' : path.first.toString();
  } else {
    nameMessage = 'Value';
  }

  var errorMessage = '$nameMessage expected to be  ${_typeOf<T>().toString()} but it is ${value.runtimeType}.';

  if (!hasTypeConverter) {
    errorMessage += ' Did you forget to pass value mapper parameter?';
  }

  return errorMessage;
}

T _asType<T>(dynamic val, List<dynamic> atPath, [T Function(dynamic)? typeMapper]) {
  if (typeMapper != null) {
    return typeMapper(val);
  }

  try {
    return val as T;
  } catch (_) {
    throw JsonLibException(_formatTypeMismatchMessage<T>(atPath, val, typeMapper != null));
  }
}

dynamic? _jsonSubscript(dynamic fieldOrIndex, dynamic data) {
  if (data is Map) {
    if (fieldOrIndex is String) {
      return data[fieldOrIndex];
    } else {
      throw JsonLibException(
          'Jason data is a Map but path value $fieldOrIndex is not a String. Only string values accepted as a json map keys');
    }
  } else if (data is List) {
    if (fieldOrIndex is int) {
      if (fieldOrIndex <= data.length) {
        return data[fieldOrIndex];
      } else {
        return null;
      }
    } else {
      throw JsonLibException(
          'Jason data is a List but path value $fieldOrIndex is not an Int. Only Int values accepted as an index of the list');
    }
  } else {
    throw JsonLibException(
        'Unexpected Json type of ${data.runtimeType} found as a target of pat value $fieldOrIndex. Map or List where expected');
  }
}

T? _jsonPathValue<T>(
    {required List<dynamic> pathLeft,
    required List<dynamic> pathReached,
    required dynamic data,
    required bool allowMissingValue,
    T Function(dynamic)? valueMapper}) {
  if (pathLeft.isEmpty) {
    return _asType(data, pathReached, valueMapper);
  }

  final newPathLeft = List<dynamic>.of(pathLeft);
  final dynamic fieldOrIndex = newPathLeft.removeAt(0);
  final newPathReached = pathReached + <dynamic>[fieldOrIndex];

  if (fieldOrIndex == null) {
    throw JsonLibException('Unexpected null value in the path');
  }

  final dynamic? val = _jsonSubscript(fieldOrIndex, data);
  if (val == null) {
    if (allowMissingValue) {
      return null;
    } else {
      throw JsonLibException(_formatValueNotFoundMessage(newPathReached));
    }
  }

  return _jsonPathValue(
      pathReached: newPathReached,
      pathLeft: newPathLeft,
      data: val,
      allowMissingValue: allowMissingValue,
      valueMapper: valueMapper);
}

T jsonPathValue<T>(List<dynamic> path, dynamic data, [T Function(dynamic)? valueMapper]) {
  return _jsonPathValue(
      pathLeft: path, pathReached: <dynamic>[], data: data, allowMissingValue: false, valueMapper: valueMapper)!;
}

T? jsonPathValueOptional<T>(List<dynamic> path, dynamic data, [T Function(dynamic)? valueMapper]) {
  return _jsonPathValue(
      pathLeft: path, pathReached: <dynamic>[], data: data, allowMissingValue: true, valueMapper: valueMapper);
}

Map<String, dynamic> asJsonMap(dynamic data) {
  try {
    return data as Map<String, dynamic>;
  } catch (_) {
    throw JsonLibException('Data object expected to be a Map<String, dynamic> but it is ${data.runtimeType}');
  }
}

List<T> asJsonList<T>(dynamic data, [T Function(dynamic)? itemMapper]) {
  try {
    return itemMapper == null ? data as List<T> : (data as List<dynamic>).map(itemMapper).toList();
  } catch (_) {
    final expectedType = _typeOf<T>().toString();
    throw JsonLibException('Data object expected to be a List<$expectedType> but it is ${data.runtimeType}');
  }
}

T jsonValue<T>(String fieldName, dynamic data, [T Function(dynamic)? valueMapper]) {
  return jsonPathValue(<dynamic>[fieldName], data, valueMapper);
}

T? tryJsonValue<T>(
  String fieldName,
  dynamic data, [
  T Function(dynamic)? valueMapper,
]) {
  return jsonPathValueOptional(<dynamic>[fieldName], data, valueMapper);
}

List<T> jsonValueList<T>(String fieldName, dynamic data, [T Function(dynamic)? listItemMapper]) {
  final dynamic listVal = jsonPathValue<dynamic>(<dynamic>[fieldName], data);

  return asJsonList(listVal, listItemMapper);
}

List<T>? tryJsonValueList<T>(String fieldName, dynamic data, [T Function(dynamic)? listItemMapper]) {
  final dynamic listVal = jsonPathValueOptional<dynamic>(<dynamic>[fieldName], data);
  return listVal == null ? null : asJsonList(listVal, listItemMapper);
}

T jsonListItem<T>(int index, dynamic data, [T Function(dynamic)? listItemMapper]) {
  return jsonPathValue(<dynamic>[index], data, listItemMapper);
}

T? tryJsonListItem<T>(int index, dynamic data, [T Function(dynamic)? listItemMapper]) {
  return jsonPathValueOptional(<dynamic>[index], data, listItemMapper);
}
