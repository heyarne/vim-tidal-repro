{
  description = "A Tidal Cycles project. https://tidalcycles.org/";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.tidal.url = "github:mitchmindtree/tidalcycles.nix";
  inputs.tidal.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs:
    inputs.tidal.utils.eachSupportedSystem (system:
    let
      pkgs = import inputs.nixpkgs { inherit system; };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          # vim with vim-tidal
          (pkgs.vim-full.customize {
            name = "vim";
            vimrcConfig.packages.plugins = {
              start = [inputs.tidal.packages.${system}.vim-tidal];
              opt = [];
            };
          })

          # neovim with vim-tidal
          (pkgs.neovim.override {
            configure.packages.plugins = {
              start = [inputs.tidal.packages.${system}.vim-tidal];
              opt = [];
            };
          })
        ];
      };
    });
}
