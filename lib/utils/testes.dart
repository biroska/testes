import 'dart:io';

import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:intl/intl.dart';
import 'package:testes/model/certificate_complete_info.dart';

import '../model/certificate_basic_info.dart';

Future<void> main() async {

  try {
    // certutil -store -silent -user my
    String run = await runCertutil();

    print('Dados Brutos');
    print(run);
    print('===========================================');

    List<String> certificatesString = listOfStringCertificateInfo(run);
    print('Store dos certificados: ${certificatesString[0]}');
    print('Quantidade de certificados: ${certificatesString.length - 1}');

    String data = certificatesString[4];
    print(data);

    CertificateCompleteInfo complete = buildCertificateCompleteInfo(data);
    print(complete);

    String emissor = extractCertificateInfo(complete.emissor, 'CN=', ',');
    print(emissor);

    String requerente = extractCertificateInfo(complete.requerente, 'CN=', ',');
    print(requerente);

    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    DateTime notBefore = dateFormat.parse(complete.notBefore);
    print(notBefore);

    DateTime notAfter = dateFormat.parse(complete.notAfter);
    print(notAfter);

    List<String> all = complete.requerente.split(', ');
    print(complete.requerente);

    List<String> ous = all.where((item) => item.contains('OU=')).toList();
    bool isA3 = ous.where((item) => item.contains('A3')).isNotEmpty;
    String type = isA3 ? 'A3' : '';

    if (!isA3) {
      bool isA1 = ous.where((item) => item.contains('A1')).isNotEmpty;
      type = isA1 ? 'A1' : '';
    }

    String document='';
    // Aasdasd Aasdads:28349950675
    if ( requerente.contains(":") ){ // Verifica se o requerente possui :
      int ultimoDoisPontos = requerente.lastIndexOf(":");
      print(ultimoDoisPontos);
      print(requerente);
      document = requerente.substring( ultimoDoisPontos+1);

      if ( CPFValidator.isValid( document ) ) {
        document = CPFValidator.format( document );
      } else
      if ( CNPJValidator.isValid( document ) ) {
        document = CNPJValidator.format( document );
      }

      print(document);
    }

    CertificateInfo certificateInfo = CertificateInfo(
        serialNumber: complete.serialNumber,
        requerente: requerente,
        notBefore: notBefore,
        notAfter: notAfter,
        emissor: emissor,
        type: type,
        document: document);
    print(certificateInfo);


  } on ProcessException catch (e) {
    print(e);
  } finally {
    print('Processo concluido');
  }
}

CertificateCompleteInfo buildCertificateCompleteInfo(String data) {
  try {
    String serialNumber = extractCertificateInfo(data, 'Número de Série: ', 'Emissor:');
    String emissor = extractCertificateInfo(data, 'Emissor: ', 'NotBefore:');
    String notBefore = extractCertificateInfo(data, 'NotBefore: ', 'NotAfter:');
    String notAfter = extractCertificateInfo(data, 'NotAfter: ', 'Requerente:');
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

// Split da string retornada pelo certutil em lista, quebrando por
// ================ Certificado 8 ================
List<String> listOfStringCertificateInfo(String run) {
  final re = RegExp(r'================ Certificado *[0-9] ================');
  return run.split(re);
}

Future<String> runCertutil() async {

  var result =
      await Process.run('certutil', ['-store', '-silent', '-user', 'my']);

  int exitCode = result.exitCode;
  print('exit code: $exitCode');

  if (exitCode != 0) {
    throw ProcessException('certutil', [
      'Ocorreu um erro na execucao do Certutil',
      'Exit code: ${exitCode.toString()}'
    ]);
  }

  return result.stdout;
}
