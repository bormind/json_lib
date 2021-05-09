import 'package:json_lib/json_lib.dart';
import 'package:json_lib/json_lib_extensions.dart';

class Album {
  final String name;
  final Artist artist;
  final List<Track> tracks;

  Album({
    required this.name,
    required this.artist,
    required this.tracks,
  });

  static Album deserialize(dynamic data) {
    final json = asJsonMap(data);
    return Album(
      name: json.value('name'),
      artist: json.value('artist', Artist.deserialize),
      tracks: json.valueList('tracks', Track.deserialize),
    );
  }
}

class Artist {
  final String name;
  final int? founded;
  final List<String> members;

  Artist({
    required this.name,
    required this.founded,
    required this.members,
  });

  static Artist deserialize(dynamic data) {
    final json = asJsonMap(data);
    return Artist(
      name: json.value('name'),
      founded: json.tryValue('founded'),
      members: json.tryValueList('members') ?? [],
    );
  }
}

class Track {
  final String name;
  final int? duration;

  Track({
    required this.name,
    required this.duration,
  });

  static Track deserialize(dynamic data) {
    final json = asJsonMap(data);
    return Track(
      name: json.value('name'),
      duration: json.tryValue('duration'),
    );
  }
}
