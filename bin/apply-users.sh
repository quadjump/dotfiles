#!/bin/sh
pushd ~/dotfiles
home-manager switch -f ./users/quadjump/home.nix
popd