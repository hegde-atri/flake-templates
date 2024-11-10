{
  inputs.pkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.prisma-utils.url = "github:VanCoding/nix-prisma-utils";

  outputs =
    { pkgs, prisma-utils, ... }:
    let
      nixpkgs = import pkgs { system = "x86_64-linux"; };
      prisma =
        (prisma-utils.lib.prisma-factory {
          inherit nixpkgs;
          prisma-fmt-hash = "sha256-CyZzjiqup94khOGtZ0lIDGjY5v8cJqdWJkQb7ybg9As="; # just copy these hashes for now, and then change them when nix complains about the mismatch
          query-engine-hash = "sha256-kB5jMJRb1ptNovl5A3IdSA1u56RdQq6xvrystYc/tN8=";
          libquery-engine-hash = "sha256-PS9LHNj1WGh4WQO3FQWpX2tuUydLvfhrNJbO1WV4s6s=";
          schema-engine-hash = "sha256-zi6YFnbK4pLcQxd8OAVRI41ycNjRfZD6LTf8gTJruyU=";
        }).fromPnpmLock
          ./pnpm-lock.yaml; # <--- path to our pnpm-lock.yaml file that contains the version of prisma-engines
    in
    {
      devShells.x86_64-linux.default = nixpkgs.mkShell {
        shellHook = prisma.shellHook;
        buildInputs = with nixpkgs; [
          pnpm
          nodejs
          prettierd
          typescript
          typescript-language-server
        ];
      };
      devShells.aarch64-darwin.default = nixpkgs.mkShell {
        shellHook = prisma.shellHook;
        buildInputs = with nixpkgs; [
          pnpm
          nodejs
          prettierd
          typescript
          typescript-language-server
        ];
      };
    };
}
