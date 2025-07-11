class LocalStorageRoutes {
  static final String database = "database";
  static String stopWatch(String collectionId, int index) {
    return "stopWatch-$collectionId-$index";
  }
}
