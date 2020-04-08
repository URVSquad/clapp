library betogether.globals;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';

//TODO: This are variables used for the authentication endpoint.
// It is porbably best to refactor this somewhere else. In the meantime
// it stays here.

// Setup AWS User Pool Id & Client Id settings here:
const awsUserPoolId = 'eu-west-2_G1chdG3tq';
const awsClientId = '19j1sl25biq0uu4opvp0tv7nkp';

final userPool = new CognitoUserPool(awsUserPoolId, awsClientId);

// Setup endpoints here:
const region = 'eu-west-2';
const endpoint =
    'https://9gzf9ud1r6.execute-api.eu-west-2.amazonaws.com/dev';

String identityPoolId = 'eu-west-2:12a0d80f-f231-4c6d-9ce0-11025b35f7f9';