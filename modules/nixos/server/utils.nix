{
  self,
  inputs,
  config,
  ...
}:
let
  media-gid = 3333;
in
{
  flake.lib.server = {

    # create user in media group
    # used for services that require access to media drive
    mkMediaUser =
      {
        name,
        uid,
      }:
      {
        users.groups = {
          ${name}.gid = uid;
          media.gid = media-gid; # hardcode the media gid (i'll figure out a better way someday)
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
