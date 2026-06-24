{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.serverLib = {

    # create user in media group
    # used for services that require access to media drive
    mkMediaUser =
      {
        name,
        uid,
      }:
      let
        media-gid = config.users.groups.media.gid;
      in
      {
        users.groups = {
          ${name}.gid = uid;
          media.gid = media-gid;
        };
        users.users.${name} = {
          inherit uid;
          group = name;
          isSystemUser = true;
          extraGroups = [ "media" ];
        };
      };
  };
}
