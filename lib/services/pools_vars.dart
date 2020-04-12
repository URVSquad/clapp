library betogether.globals;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';

//TODO: This are variables used for the authentication endpoint.
// It is porbably best to refactor this somewhere else. In the meantime
// it stays here.

// Setup AWS User Pool Id & Client Id settings here:
const awsUserPoolId = 'eu-west-2_F2VD3BBho';
const awsClientId = '6st9aqnvrld66lg5tndqat9m6t';

final userPool = new CognitoUserPool(awsUserPoolId, awsClientId);

// Setup endpoints here:
const region = 'eu-west-2';
const endpoint =
    'https://9gzf9ud1r6.execute-api.eu-west-2.amazonaws.com/dev';

String identityPoolId = 'eu-west-2:97717cbf-ea7d-4a4d-9ca9-45dc846d8b55';