var inputRequest = keycloakSession.getContext().getHttpRequest();
var params = inputRequest.getDecodedFormParameters();
var email = user.getEmail();
print("email: " + email);
exports = "oidc:" + email;