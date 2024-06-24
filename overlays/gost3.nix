{ stdenv, lib, fetchFromGitHub, buildGoModule, fetchpatch }:
buildGoModule rec {
  pname = "gost3";
  version = "v3.0.0-nightly.20240624";

  src = fetchFromGitHub {
    owner = "go-gost";
    repo = "gost";
    rev = "${version}";
    sha256 = "sha256-w/tD6Z3fM+PgqTTBW1SKUMNw8Hl+Jxl7UgcQSTeP1F4=";
  };

  vendorHash = "sha256-xvMx55XdxtY+dSkj7rdu4TUk+xKi0yoeJ1sME6lxnek=";

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "GO Simple Tunnel - a simple tunnel written in golang";
    homepage = "https://github.com/go-gost/gost";
    license = licenses.mit;
    maintainers = with maintainers; [ pmy ];
    mainProgram = "gost";
  };
}
