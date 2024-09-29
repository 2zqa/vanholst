import 'package:html_character_entities/html_character_entities.dart';

String? decodeOrNull(String? string) {
  if (string == null) {
    return null;
  }
  return HtmlCharacterEntities.decode(string);
}
