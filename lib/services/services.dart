import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<DeployedContract> getContract() async {
  final CONTRACT_NAME = dotenv.env['CONTRACT_NAME']
}