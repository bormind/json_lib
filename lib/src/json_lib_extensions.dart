import '../json_lib.dart' as json_lib;

extension JsonMapExtensions on Map<String, dynamic> {
  T pathValue<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValue(path, this, valueMapper);
  }

  T? tryPathValue<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValueOptional<T>(path, this, valueMapper);
  }

  T value<T>(String fieldName, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonValue(fieldName, this, valueMapper);
  }

  T? tryValue<T>(
    String fieldName, [
    T Function(dynamic)? valueMapper,
  ]) {
    return json_lib.tryJsonValue(fieldName, this, valueMapper);
  }

  List<T> valueList<T>(String fieldName, [T Function(dynamic)? listItemMapper]) {
    return json_lib.jsonValueList(fieldName, this, listItemMapper);
  }

  List<T>? tryValueList<T>(String fieldName, [T Function(dynamic)? listItemMapper]) {
    return json_lib.tryJsonValueList(fieldName, this, listItemMapper);
  }
}

extension JsonListExtensions on List<dynamic> {
  T pathValue<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValue(path, this, valueMapper);
  }

  T? tryPathValue<T>(List<dynamic> path, [T Function(dynamic)? valueMapper]) {
    return json_lib.jsonPathValueOptional<T>(path, this, valueMapper);
  }

  T listItem<T>(int index, [T Function(dynamic)? listItemMapper]) {
    return json_lib.jsonListItem(index, this, listItemMapper);
  }

  T? tryListItem<T>(int index, [T Function(dynamic)? listItemMapper]) {
    return json_lib.tryJsonListItem(index, this, listItemMapper);
  }
}
