var this_year = DateTime.now().year.toString();

class AppConfig {
  //configure this
  static String copyright_text =
      "@HAXUVINA. All rights reserved " + this_year;
  static String app_name =
      "Haxuvina";
  static String search_bar_text =
      "Tìm kiếm...";
  static String system_key =
      r"99ca31ee-b350-46c0-802a-45a2444fb252";

  //Default language config
  static String default_language = "vi";
  static String mobile_app_code = "vi";
  static bool app_language_rtl = false;

  //configure this
  static const bool HTTPS =
      true; //if you are using localhost , set this to false
  static const DOMAIN_PATH =
      "sint.vn"; //use only domain name without http:// or https://

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";

  @override
  String toString() {
    return super.toString();
  }
}
