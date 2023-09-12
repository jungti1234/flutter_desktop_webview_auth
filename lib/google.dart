import 'src/provider_args.dart';
import 'src/util.dart';

const _defaultSignInScope = 'https://www.googleapis.com/auth/plus.login';

class GoogleSignInArgs extends ProviderArgs {
  final String clientId;
  final String scope;
  final String responseType;
  final String accessType;
  final bool immediate;
  final GoogleSignInArgsPrompt? prompt;

  @override
  final String redirectUri;

  @override
  final host = 'accounts.google.com';

  @override
  final path = '/o/oauth2/v2/auth';

  GoogleSignInArgs({
    required this.clientId,
    required this.redirectUri,
    this.scope = _defaultSignInScope,
    this.responseType = 'token id_token code',
    this.accessType = 'offline',
    this.immediate = false,
    this.prompt,
  });

  @override
  Map<String, String> buildQueryParameters() {
    return {
      'client_id': clientId,
      'scope': scope,
      'response_type': responseType,
      'redirect_uri': redirectUri,
      'access_type': accessType,
      "nonce": generateNonce(),
      if (prompt == null) ...{'immediate': immediate.toString()},
      if (prompt != null) ...{'prompt': prompt!.getValue},
    };
  }
}

enum GoogleSignInArgsPrompt { none, consent, selectAccount }

extension PromptExtension on GoogleSignInArgsPrompt {
  String get getValue {
    switch (this) {
      case GoogleSignInArgsPrompt.consent:
        return 'consent';
      case GoogleSignInArgsPrompt.selectAccount:
        return 'select_account';
      default:
        return 'none';
    }
  }
}
