{
  description = "A simple flake for building a LaTeX document";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [ pkgs.texliveFull ];
      };

      packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
        name = "cv";
        src = ./.;
        buildInputs = [ pkgs.texliveFull ];
        buildPhase = ''
          latexmk -pdf cv_english.tex
          latexmk -pdf cv_portuguese.tex
        '';
        installPhase = ''
          mkdir -p $out
          cp cv_english.pdf $out/Gabriele_Vieira_Eng.pdf
          cp cv_portuguese.pdf $out/Gabriele_Vieira_Por.pdf
        '';
      };
    };
}