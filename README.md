Library made to simplify working with Json Data 
- intuitive API
- no code generation
- support for required and missing(optional) jason data
- descriptive error reporting

### Motivation

This Library is useful when you:
 - are not interested in automatic code generated deserialization.
- want better control when handling unexpected Json data. 
- want to read only parts of the Json data by path or by name.  

### APIs
There are two 'flavors' of the api - freestanding functions and extensions on `Map<String, dynamic>` and `List<dynamic>`

Every json reading function has two variations: 
- 'strict' - data expected to be present and not null. If data is missing function will throw an exception explaining the missing part.
- 'try' Prefixed - function will return null.

Every function has optional 'mapper' parameter that can be used to map retrieved value to expected data type.

There are two convenience functions `asJsonMap(dynamic)` and `asJsonList(dynamic)` that are used in combination with extension methods.


### Usage
For complete API and code examples please refer to [json_lib_test](https://github.com/bormind/json_lib/blob/main/test/json_lib_test.dart) and [json_lib_test_extensions](https://github.com/bormind/json_lib/blob/main/test/json_lib_extensions_test.dart) 

Imports
```dart
import 'package:json_lib/json_lib.dart';
// Only if extension methods used
import 'package:json_lib/json_lib_extensions.dart';
```
Property names and list indexes (freestanding functions)
```dart
final dynamic data = {'intField': 5, 'stringField': 'foo', 'doubleField': 2.3, 'nullField': null};
final dynamic dataList = <dynamic>[1, 'foo', 3];

final double someValue = jsonValue('doubleField', data); // 2.3
final double someValue = tryJsonValue('missing_filed', data); //null

final String val = jsonListItem(1, dataList); // 'foo'
final String val = tryJsonListItem(300, dataList); // null
```
Property names and list indexes (extensions)
```dart
final jsonObject = asJsonMap(data);
final jsonList = asJsonList(dataList);

final double someValue = jsonObject.value('doubleField'); // 2.3
final double someValue = jsonObject.tryValue('missing_filed'); // null
final String val = jsonList.listItem(1); // 'foo'
final String val = jsonList.tryListItem(300); // null
```

Using path
```dart
//sample data
final dynamic responseBody = [{
    'name': 'Songs from a Room',
    'genre': 'Folk',
    'artist': {
      'name': 'Leonard Cohen',
    },
    'tracks': [
      {'name': 'Bird on the Wire', 'duration': 208},
      {'name': 'Story of Isaac', 'duration': 218},
      {'name': 'A Bunch of Lonesome Heroes', 'duration': 198},
    ]
  }
];
```
Freestanding functions
```dart
// this will throw exception if path is not found with description which part of the path is missing in the data
final int trackDuration = jsonPathValue([1, 'tracks', 0, 'duration'], responseBody); // 208
// this will not throw byt return nullable value
final int? trackDuration = tryJsonPathValue([1, 'tracks', 0, 'duration'], responseBody); // 208
final int? trackDuration = tryJsonPathValue([5, 'tracks', 0, 'duration'], responseBody); // null - index 5 is out of bounds
```
Extensions
```dart
final jsonData = asList(responseBody);
// this will throw exception if path is not found with description which part of the path is missing in the data
final int trackDuration = jsonData.pathValue([1, 'tracks', 0, 'duration']);  // 208
// this will not throw byt return nullable value
final int? trackDuration = jsonData.tryPathValue([1, 'tracks', 0, 'duration']);  // 208
final int? trackDuration = jsonData.tryPathValue([5, 'tracks', 0, 'duration']);  // null - index 5 is out of bounds
```
Using mapper parameters
```dart
enum Genre { Rock, Jazz, Pop, Folk }

Genre? tryParseGenre(dynamic value) {
  return Genre.values.firstWhereOrNull((e) => e.toString().toLowerCase() == 'genre.${value.toString().toLowerCase()}');
}

Genre genre = albumsJson.pathValue([0, 'genre'], tryParseGenre); // Genre.Folk
```
Deserializing hierarchical data
```dart 
  static Album deserialize(dynamic data) {
    final json = asJsonMap(data);
    return Album(
      name: json.value('name'),
      artist: json.value('artist', Artist.deserialize),
      tracks: json.valueList('tracks', Track.deserialize),
      genre: json.value('genre', tryParseGenre),
    );
  }

  static Artist deserialize(dynamic data) {
    final json = asJsonMap(data);
    return Artist(
      name: json.value('name'),
      founded: json.tryValue('founded'),
      members: json.tryValueList('members') ?? [],
    );
  }

  static Track deserialize(dynamic data) {
    final json = asJsonMap(data);
    return Track(
      name: json.value('name'),
      duration: json.tryValue('duration'),
    );
  }
```





