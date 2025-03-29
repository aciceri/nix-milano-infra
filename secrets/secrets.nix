let
  users = builtins.fromJSON (builtins.readFile "../users.json"));
in
{
  "github_token.age".publicKeys = [ users.aciceri.publicKey ];
}
