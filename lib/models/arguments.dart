import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/models/news.dart';

class SingleNewsViewArguments {
  final News news;

  const SingleNewsViewArguments({required this.news});
}

class SingleCryptoViewArguments {
  final Crypto crypto;

  const SingleCryptoViewArguments({
    required this.crypto,
  });
}