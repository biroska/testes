class CertificateCompleteInfo {

  String emissor;
  String notAfter;
  String notBefore;
  String requerente;
  String serialNumber;

  CertificateCompleteInfo(
      {required this.emissor,
      required this.notAfter,
      required this.notBefore,
      required this.requerente,
      required this.serialNumber});



  @override
  String toString() {
    return 'CertificateCompleteInfo{\n serialNumber: $serialNumber;\n requerente: $requerente;\n emissor: $emissor;\n notAfter: $notAfter;\n notBefore: $notBefore \n}';
  }
}