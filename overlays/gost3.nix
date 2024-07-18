{ stdenv, lib, fetchFromGitHub, buildGoModule, fetchpatch }:
buildGoModule rec {
  pname = "gost3";
  version = "v3.0.0-nightly.20240715";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    rev = "${version}";
    sha256 = "sha256-+y4aPXaeCbQsveh3yBFiiBDlt/d0M92OPkLK/IcR7E4=";
  };

  vendorHash = "sha256-dplaq96NtCf5HdbnHes4cOVq7jMmDZXhpB9aDDXMhWA=";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "GO Simple Tunnel - a simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "gost";
  };
}
