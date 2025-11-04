{
  description = "kubectl development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    yaookctl.url = "gitlab:yaook/yaookctl";
    yaookctl.inputs.nixpkgs.follows = "nixpkgs";
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
            export YAOOK_VERSION=$(helm search repo yaook.cloud/crds -o json | jq -r '.[0].version')
            
            echo "KUBECONFIG: $KUBECONFIG"
            echo "YAOOK_VERSION: $YAOOK_VERSION"
            echo ""
            echo "kubectl: $(kubectl version --client -o json 2>/dev/null | jq -r '.clientVersion.gitVersion' || echo 'unknown')"
            echo "helm: $(helm version --short 2>/dev/null | cut -d'+' -f1 || echo 'unknown')"
            echo "yq: $(yq --version 2>/dev/null || echo 'unknown')"
            echo "k9s: $(k9s version -s | head -n1 | awk '{print $NF}' 2>/dev/null || echo 'unknown')"
            echo "yaookctl: $(yaookctl --version 2>/dev/null || echo 'unknown')"
          '';
        };
      }
    );
}
