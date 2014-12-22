library storage;

import 'dart:html';

class Storage {
  static String get(String key) {
    return window.localStorage[key];
  }

  static bool hasKey(String key) {
    return window.localStorage.containsKey(key) && window.localStorage[key].isNotEmpty;
  }

  static set(String key, String value) {
    window.localStorage[key] = value;
  }
}