{
  lib,
  config,
  charts,
  ...
}:
let
  cfg = config.services.traefik;

  namespace = "traefik";
  values = lib.attrsets.recursiveUpdate {
    ingressClass = {
      enabled = true;
      isDefaultClass = true;
      name = cfg.ingressClassName;
    };
    providers.kubernetesIngress.publishedService.enabled = true;
  } cfg.values;
in
{
  options.services.traefik = with lib; {
    enable = mkEnableOption "the traefik";
    ingressClassName = mkOption {
      type = types.str;
      default = "traefik";
    };
    values = mkOption {
      type = types.attrsOf types.anything;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    applications.traefik = {
      inherit namespace;
      createNamespace = true;

      helm.releases.traefik = {
        chart = charts.traefik.traefik;

        inherit values;
      };
    };
  };
}
