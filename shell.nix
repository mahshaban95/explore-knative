{ pkgs ? import <nixpkgs> {} }:pkgs.mkShell {
  packages = with pkgs; [
    kind
    kubectl
    kn
  ];
  shellHook = ''
    # This command will be executed whenever you enter the Nix shell environment
    brew install knative-extensions/kn-plugins/quickstart
  '';
}
