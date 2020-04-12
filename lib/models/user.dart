import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class User {
  String email;
  String name;
  String password;
  String username;

  String website;
  String description;
  String nif;
  bool is_enterprise;

  String repeatedPassword;
  String sub;
  bool confirmed = false;
  bool hasAccess = false;

  User({this.email, this.name});

  /// Decode user from Cognito User Attributes
  factory User.fromUserAttributes(List<CognitoUserAttribute> attributes) {
    final user = User();
    attributes.forEach((attribute) {
      if (attribute.getName() == 'email') {
        user.email = attribute.getValue();
      } else if (attribute.getName() == 'name') {
        user.name = attribute.getValue();
      } else if (attribute.getName() == 'sub') {
        user.sub = attribute.getValue();
      } else if (attribute.getName() == 'website') {
        user.website = attribute.getValue();
      } else if (attribute.getName() == 'custom:nif') {
        user.nif = attribute.getValue();
      } else if (attribute.getName() == 'custom:description') {
        user.description = attribute.getValue();
      } else if (attribute.getName() == 'custom:enterprise') {
        if(attribute.getValue() == "1"){
          user.is_enterprise = true;
        } else{
          user.is_enterprise = false;
        }
      }

    });
    return user;
  }
}