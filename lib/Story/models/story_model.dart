import 'package:meta/meta.dart';
import 'package:surichatapp/Story/models/user_model.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final String url;
  final MediaType media;
  final Duration duration;

  const Story({
    @required this.url,
    @required this.media,
    @required this.duration,
  });
}
