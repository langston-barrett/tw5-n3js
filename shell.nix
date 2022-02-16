{ pkgs ? import <nixpkgs> { }
, unstable ? import <unstable> { }
}:

pkgs.mkShell {
  buildInputs =  [
    unstable.nodejs_latest
  ];
}
