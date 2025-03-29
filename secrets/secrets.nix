let
  users = builtins.fromJSON (builtins.readFile ../users.json);
  publicKeys = builtins.foldl'
    (users: user: users // {
      "${user.username}" = user.publicKey;
    })
    { }
    users;
in
with publicKeys;
{
  "github_token.age".publicKeys = [ aciceri albertodvp ];
}
