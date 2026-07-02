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

    # create system user in media group with specified name and uid/gid
    # used for services that require access to media drive
    mkMediaUser =
      {
        name,
        uid,
      }:
      {
        groups = {
          ${name}.gid = uid;
          media.gid = media-gid; # hardcode the media gid (i'll figure out a better way someday)
        };
        users.${name} = {
          inherit uid;
          group = name;
          isSystemUser = true;
          extraGroups = [ "media" ];
        };
      };

    # create system user with the specified name and uid/gid
    mkServiceUser =
      {
        name,
        uid,
      }:
      {
        groups = {
          ${name}.gid = uid;
        };
        users.${name} = {
          inherit uid;
          group = name;
          isSystemUser = true;
        };
      };
  };
}
