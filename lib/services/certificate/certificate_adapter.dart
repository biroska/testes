import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:intl/intl.dart';

import '../../model/certificate_basic_info.dart';
import '../../model/certificate_complete_info.dart';

class CertificateAdapter {


  CertificateInfo certificateInfoAdapter(String data) {
    CertificateCompleteInfo complete = buildCertificateCompleteInfo(data);

    String emissor = extractCertificateInfo(complete.emissor, 'CN=', ',');

    String requerente = extractCertificateInfo(complete.requerente, 'CN=', ',');

    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    DateTime notBefore = dateFormat.parse(complete.notBefore);

    DateTime notAfter = dateFormat.parse(complete.notAfter);

    List<String> all = complete.requerente.split(', ');

    List<String> ous = all.where((item) => item.contains('OU=')).toList();
    bool isA3 = ous.where((item) => item.contains('A3')).isNotEmpty;
    String type = isA3 ? 'A3' : '';

    if (!isA3) {
      bool isA1 = ous.where((item) => item.contains('A1')).isNotEmpty;
      type = isA1 ? 'A1' : '';
    }

    String document = '';
    // Aasdasd Aasdads:28349950675
    if (requerente.contains(":")) {
      // Verifica se o requerente possui :
      int ultimoDoisPontos = requerente.lastIndexOf(":");
      document = requerente.substring(ultimoDoisPontos + 1);

      if (CPFValidator.isValid(document)) {
        document = CPFValidator.format(document);
      } else if (CNPJValidator.isValid(document)) {
        document = CNPJValidator.format(document);
      }
    }

    CertificateInfo certificateInfo = CertificateInfo(
        serialNumber: complete.serialNumber,
        requerente: requerente,
        notBefore: notBefore,
        notAfter: notAfter,
        emissor: emissor,
        type: type,
        document: document);

    return certificateInfo;
  }

  CertificateCompleteInfo buildCertificateCompleteInfo(String data) {
    try {
      String serialNumber =
          extractCertificateInfo(data, 'Número de Série: ', 'Emissor:');
      String emissor = extractCertificateInfo(data, 'Emissor: ', 'NotBefore:');
      String notBefore =
          extractCertificateInfo(data, 'NotBefore: ', 'NotAfter:');
      String notAfter =
          extractCertificateInfo(data, 'NotAfter: ', 'Requerente:');
      String requerente = extractCertificateInfo(data, 'Requerente: ', '\n');

      return CertificateCompleteInfo(
          emissor: emissor,
          notAfter: notAfter,
          notBefore: notBefore,
          requerente: requerente,
          serialNumber: serialNumber);
    } on Exception catch (e) {
      print('Ocorreu um erro ao converter o certificado: $data');
      throw FormatException(
          'Ocorreu um erro ao converter o certificado: ${e.toString()}');
    }
  }

  String extractCertificateInfo(
      String data, String certificateStartField, String certificateNextField) {
    try {
      if (data.contains(certificateStartField)) {
        final startIndex = data.indexOf(certificateStartField);
        final endIndex = data.indexOf(
            certificateNextField, startIndex + certificateStartField.length);

        String fieldValue =
            data.substring(startIndex + certificateStartField.length, endIndex);

        return fieldValue.replaceAll("\n", '').replaceAll("\r", '');
      }
    } on Exception catch (e) {
      print(
          'Ocorreu um erro ao converter o campo: $certificateStartField - erro: ${e.toString()}');
      throw FormatException(
          'Ocorreu um erro ao converter o campo: $certificateStartField',
          e.toString());
    }

    return 'Empty';
  }
}
