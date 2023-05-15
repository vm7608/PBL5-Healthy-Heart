class API {
  static String host = "192.168.0.2";
  static String address = "predict2";

  static String get url {
    return API.host.toString() + API.address.toString();
  }

  static void set(host, address) {
    API.host = host;
    API.address = address;
  }
}