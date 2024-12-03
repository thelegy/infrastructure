{
  lib,
  config,
  charts,
  ...
}:
let
  cfg = config.services.openshift-console;

  namespace = "kube-system";
  values = lib.attrsets.recursiveUpdate {
    auth-token = "TODO";
    image.tag = "4.5";
  } cfg.values;
in
{
  options.services.openshift-console = with lib; {
    enable = mkEnableOption "the openshift web console";
    values = mkOption {
      type = types.attrsOf types.anything;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    applications.openshift-console = {
      inherit namespace;

      helm.releases.openshift-console = {
        chart = ./.;
        inherit values;
      };
    };
  };
}
