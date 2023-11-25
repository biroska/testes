class FormatUtils {

  static String formatName(String commonName){
    if ( commonName.trim().isEmpty ){
      return commonName;
    }

    commonName = commonName.trim();

    int posSeparator = commonName.lastIndexOf(':');

    return commonName.substring( 0, posSeparator ).trim();
  }


}