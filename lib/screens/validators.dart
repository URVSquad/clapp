String validateName(String text){
  if(text.isEmpty){
    return 'Tienes que introducir tu nombre';
  }
  return null;
}

String validateEmail(String email) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  print(regex.allMatches(email));
  if (!regex.hasMatch(email))
    return 'Parece que esto no es un correo electrónico';
  else
    return null;
}

String validateUsername(String username){
  Pattern pattern = r'^([\w]+)$';
  RegExp regex = new RegExp(pattern);
  print(regex.allMatches(username));
  if (!regex.hasMatch(username))
    return 'El nombre de usuario solo puede contener letras y\nnúmeros';
  else
    return null;
}

String validatePassword(String password){
  if (password != null && password.length < 8){
    return 'La contraseña debe tener almenos 8 carácteres';
  }
  return null;
}
