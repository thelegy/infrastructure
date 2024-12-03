{
  imports = [
    ./argocd.nix
    ./openshift-console
    ./traefik.nix
  ];
  nixidy.target.repository = "https://github.com/thelegy/infrastructure.git";
  nixidy.target.rootPath = "./manifests/";
}
