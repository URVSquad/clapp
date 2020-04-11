library betogether.globals;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';

//TODO: This are variables used for the authentication endpoint.
// It is porbably best to refactor this somewhere else. In the meantime
// it stays here.

// Setup AWS User Pool Id & Client Id settings here:
const awsUserPoolId = 'eu-west-2_qFG6yYFNz';
const awsClientId = '59bspg936bri0uo7k7vbcbcsl3';

final userPool = new CognitoUserPool(awsUserPoolId, awsClientId);

// Setup endpoints here:
const region = 'eu-west-2';
const endpoint =
    'https://9gzf9ud1r6.execute-api.eu-west-2.amazonaws.com/dev';

String identityPoolId = 'eu-west-2:b2246e18-8d97-4daf-b8cb-277a351f1fdd';