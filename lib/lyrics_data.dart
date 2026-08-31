class LyricsData {
  // ============ LIRIK LAGU ============
  static const Map<String, String> _lyrics = {
    'Another Day':
        'Live another day, climb a little higher Find another reason to stay\n'
        'Ashes in your hands, mercy in your eyes\n'
        'If youre searching for a silent sky\n'
        '\n'
        'You wont find it here, look another way\n'
        'You wont find it here, so die another day\n'
        '\n'
        'The coldness of his words, the message in his silence "Face the candle to the wind"\n'
        'This distance in my voice isnt leaving you a choice\n'
        'So if youre looking for a time to run away\n'
        '\n'
        'You wont find it here, look another way\n'
        'You wont find it here, so die another day\n'
        '\n'
        'They took pictures of our dreams, ran to hide behind the stairs\n'
        'And said, "Maybe when its right for you, theyll fall"\n'
        'But if they dont come down, resist the need to pull them in\n'
        'And throw them away, better to save the mystery\n'
        'Than surrender to the secret, whoa-oh\n'
        '\n'
        'You wont find it here, look another way\n'
        'You wont find it here, so die another day\n',

    'Charles (Self Cover)':
        'Sayonara wa anata kara itta\n'
        'Sore na no ni hoo wo nurashite shimau no\n'
        'Sou yatte kinou no koto mo keshite shimau nara mou ii yo\n'
        'Waratte\n'
        '\n'
        'Hanataba wo kakaete aruita\n'
        'Imi mo naku tada machi wo mioroshita\n'
        'Kou yatte risou no fuchi ni\n'
        'Kokoro wo okisatteiku mou ii ka\n'
        'Karappo de iyou sore de itsuka\n'
        'Fukai ao de mitashita No nara dou darou konna fuu ni\n'
        'Nayameru no ka na\n'
        '\n'
        'Ai wo utatte utatte kumo no ue\n'
        'Nigorikitte wa mienai ya Iya iya\n'
        'Tooku egaiteta hibi wo\n'
        'Katatte katatte yoru no mure\n'
        'Igamiatte kiri ga nai na Ina ina\n'
        'Waraiatte sayonara\n'
        '\n'
        'Asayake to anata no tameiki\n'
        'Kono machi wa bokura no yume wo miteru\n'
        'Kyou datte tagai no koto wo wasureteikunda ne\n'
        'Nee sou desho\n'
        'Damatteiyou sore de itsuka\n'
        'Sainamareta to shite mo\n'
        'Betsu ni iinda yo konna urei mo\n'
        'Imi ga aru nara\n'
        '\n'
        'Koi to kazatte kazatte shizuka na hou e\n'
        'Yogorekitta kotoba wo ima Ima ima\n'
        '[Koko ni wa dare mo inai] [ee, sou ne]\n'
        'Mazatte mazatte futari no hate\n'
        'Yuzuriatte nani mo nai na Ina ina\n'
        'Itami datte oshiete\n'
        '\n'
        'Kitto kitto wakatteita\n'
        'Damashiau nante bakarashii yo na\n'
        'Zutto zutto mayotteita\n'
        'Hora ne bokura wa kawarenai\n'
        'Sou darou tagai no sei de\n'
        'Ima ga aru no ni\n'
        '\n'
        'Ai wo utatte utatte kumo no ue\n'
        'Nigorikitte wa mienai ya Iya iya\n'
        'Hinihini fueteita koukai wo\n'
        'Katatte katatte yoru no mure\n'
        'Yurushiatte imi mo nai na Ina ina\n'
        '\n'
        'Ai wo utatte utatte kumo no ue\n'
        'Katatte katatte yoru no mure\n'
        'Waraiaatte sayonara',
  };

  // ============ DATA COVER ============
  static const Map<String, Map<String, String>> _songData = {
    'Another Day': {'cover': 'assets/image/another_day.jpg'},
    'Charles (Self Cover)': {'cover': 'assets/image/covers/charles.jpg'},
    'Wake Me Up When September Ends': {'cover': 'assets/image/wake_me_up.jpg'},
    'My Way Of Life': {'cover': 'assets/image/my_way_of_life.jpg'},
    'Titik Nadir': {'cover': 'assets/image/titik_nadir.jpg'},
    'Rap God': {'cover': 'assets/image/rap_god.jpg'},
    'My Way': {'cover': 'assets/image/my_way.jpg'},
    'Smells Like Teen Spirit': {
      'cover': 'assets/image/smells_like_teen_spirit.jpg',
    },
    'Nomad': {'cover': 'assets/image/covers/nomad.jpg'},
    'The Spirit Carries On': {'cover': 'assets/image/covers/thespiritcarrieson.jpg'},
    'Wirang': {'cover': 'assets/image/wirang.jpg'},
  };

  static const String _defaultCover = 'assets/image/covers/default_cover.png';

  // ============ GETTER METHODS ============
  static String getLyrics(String songTitle) {
    return _lyrics[songTitle] ??
        'No lyrics available for "$songTitle".\n\nLirik untuk lagu ini belum tersedia.\n';
  }

  static String getCover(String songTitle) {
    return _songData[songTitle]?['cover'] ?? _defaultCover;
  }

  static bool hasLyrics(String songTitle) {
    return _lyrics.containsKey(songTitle);
  }

  static bool hasCover(String songTitle) {
    return _songData.containsKey(songTitle) &&
        _songData[songTitle]!['cover'] != null;
  }

  static List<String> getSongsWithLyrics() {
    return _lyrics.keys.toList();
  }

  static List<String> getSongsWithData() {
    return _songData.keys.toList();
  }
}
