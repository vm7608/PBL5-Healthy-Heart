class API {
  static String host = "192.168.21.124";
  static String address = "predict";

  static String get url {
    return API.host.toString() + API.address.toString();
  }

  static void set(host, address) {
    API.host = host;
    API.address = address;
  }
}