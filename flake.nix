{
  description = "kubectl development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    yaookctl.url = "gitlab:yaook/yaookctl";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      yaookctl,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            kubernetes-helm
            kubectl
            k9s
            nixfmt
            yq

            yaookctl.packages.${system}.default
          ];

          shellHook = ''
            export KUBECONFIG=$(pwd)/workshop-11.yaml
            export YAOOK_OP_NAMESPACE=yaook
            export YAOOK_VERSION=$(helm search repo yaook.cloud/crds -o json | jq -r '.[0].version')

            echo "yaook set to: $YAOOK_VERSION"
            echo "kubectl $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
            echo "helm $(helm version --short 2>/dev/null || helm version)"
          '';
        };
      }
    );
}
