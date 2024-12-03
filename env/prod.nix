{
  nixidy.target.branch = "env/prod";
  services.traefik = {
    enable = true;
  };
  services.openshift-console.enable = true;
}
