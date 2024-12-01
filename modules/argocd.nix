{
  lib,
  config,
  charts,
  ...
}:
let
  cfg = config.services.argocd;

  namespace = "argocd";
  values = cfg.values;
in
{
  options.services.argocd = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
    values = mkOption {
      type = types.attrsOf types.anything;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    applications.argocd = {
      inherit namespace;

      helm.releases.argocd = {
        inherit values;
        chart = charts.argoproj.argo-cd;
      };
    };
  };
}
