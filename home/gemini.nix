{ pkgs, config, ... }: 
{
  programs.gemini-cli = {
    enable = true;
    defaultModel = "gemini-2.5-pro"; # Use a specific model
    settings = {
      ui.theme = "dark";
      general.enablePromptCompletion = true;
    };
  };
}
