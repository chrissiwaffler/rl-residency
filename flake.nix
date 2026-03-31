{
  description = "rl-residency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          python312
          uv
          git
          stdenv.cc.cc.lib # needed by some python native extensions
        ];

        env = {
          UV_PYTHON_DOWNLOADS = "never";
          UV_PYTHON = "${pkgs.python312}/bin/python3.12";
        };

        shellHook = ''
          # sync project dependencies via uv
          echo "syncing uv dependencies..."
          uv sync

          # activate uv virtual environment
          source .venv/bin/activate

          # install prime CLI via uv if not present
          if ! command -v prime &> /dev/null; then
            echo "installing prime CLI..."
            uv tool install prime
          fi

          # put uv tools on PATH
          export PATH="$HOME/.local/bin:$PATH"

          echo "dev shell ready"
          echo "  python: $(python --version)"
          echo "  uv:     $(uv --version)"
        '';
      };
    });
}
