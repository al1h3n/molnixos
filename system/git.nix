{ ... }:{
  nix = {
    settings = {
      # This globally forces Git to use blobless partial cloning AND shallow depth=1
      impure-env = [
        "GIT_CONFIG_PARAMETERS='git.cloneConfig=filter=blob:none' 'git.cloneConfig=depth=1'"
      ];
    };
  };
}