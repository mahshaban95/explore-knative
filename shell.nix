{ pkgs ? import <nixpkgs> {} }:pkgs.mkShell {
  packages = with pkgs; [
    kind
    kubectl
    kn
    func
  ];
  shellHook = ''
    # This command will be executed whenever you enter the Nix shell environment
    brew install knative-extensions/kn-plugins/quickstart
    # brew install knative-extensions/kn-plugins/func # use if you want func to be considerd a plugin in kn

  '';
}
