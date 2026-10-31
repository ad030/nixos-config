# shared values to be imported into a variable and used in nginx config
{
  flake.lib.nginx-tinyauth = {
    # append to extraConfig for tinyauth
    appendProtect =
      conf:
      conf
      + ''
        auth_request /tinyauth;
        auth_request_set $tinyauth_location $upstream_http_x_tinyauth_location;
        error_page 401 403 =302 $tinyauth_location;
      '';

    # config for locations."/tinyauth"
    locationConfig = {
      proxyPass = "http://127.0.0.1:3000/api/auth/nginx";
      extraConfig = ''
        internal;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        proxy_set_header x-forwarded-proto $scheme;
        proxy_set_header x-forwarded-host $http_host;
        proxy_set_header x-forwarded-uri $request_uri;
      '';
    };
  };
}
