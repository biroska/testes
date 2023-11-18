import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class CertificateInfo {
  final String emissor;
  final DateTime notAfter;
  final DateTime notBefore;
  final String requerente;
  final String serialNumber;
  final String document;
  final String type;

  String? level;
  bool isCpf = false;
  bool isCnpj = false;

  CertificateInfo(
      {required this.emissor,
      required this.notAfter,
      required this.notBefore,
      required this.requerente,
      required this.serialNumber,
      required this.type,
      required this.document}) :
        isCpf = CPFValidator.isValid( document ),
        isCnpj = CNPJValidator.isValid( document );



  @override
  String toString() {
    return 'CertificateInfo{emissor: $emissor, notAfter: $notAfter, notBefore: $notBefore, requerente: $requerente, serialNumber: $serialNumber, document: $document, type: $type, level: $level, isCpf: $isCpf, isCnpj: $isCnpj}';
  }
}
