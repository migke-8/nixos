{
  pkgs,
  config,
  ...
}: {
  programs.gemini-cli = {
    enable = true;
    package = pkgs.unstable.gemini-cli;
    defaultModel = "gemini-2.5-pro"; # Use a specific model
    settings = {
      ui.theme = "dark";
      general.enablePromptCompletion = true;
    };
  };
}
