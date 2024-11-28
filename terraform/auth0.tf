resource "auth0_client" "spectrum" {
  name            = "${local.prefix}"
  app_type        = "regular_web"
  callbacks       = ["https://auth.${local.prefix}.fluence.dev/oauth2/callback"]
  oidc_conformant = true
  grant_types     = ["authorization_code", "implicit", "refresh_token", "client_credentials", "password"]
}

resource "auth0_connection_client" "github_connection" {
  client_id     = auth0_client.spectrum.client_id
  connection_id = "con_QROePaRPy1BDBXxy"
}

data "auth0_client" "spectrum" {
  client_id = auth0_client.spectrum.id
}

resource "random_password" "auth0_cookie" {
  length  = 32
  special = false
  upper   = false
}
