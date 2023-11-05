# Copyright 2022 The TVL Contributors
# SPDX-License-Identifier: Apache-2.0

{ buildGoPackage, lib }:

buildGoPackage {
  name = "nixery-popcount";

  src = lib.sources.sourceFilesBySuffices ./. [
    ".sum"
    ".mod"
    ".go"
  ];

  goPackagePath = "github.com/google/nixery/popcount";
  doCheck = true;
}
