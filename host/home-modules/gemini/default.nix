{
  pkgs,
  config,
  ...
}: {
  programs.antigravity-cli = {
    enable = true;
    defaultModel = "gemini-3.1-pro";
    settings = {
      ui.theme = "dark";
      general.enablePromptCompletion = true;
    };
  };
}
