# .dotfiles for Windows

PowerShell 'dotfiles' for Windows, including common application installations through `winget`, as well as developer-friendly Windows configuration defaults.

> **Note**
> Windows Package Manager `winget` command-line tool is bundled with Windows 11 and modern versions of Windows 10 by default as the App Installer. [Read more](https://docs.microsoft.com/en-us/windows/package-manager/winget/)

## Initialization (Installation)

Open any Windows PowerShell 5.1 _(or later)_ host console with administrator rights, and run:

```posh
$GitHubRepositoryAuthor = "E-RELevant"; `
$GitHubRepositoryName = "dotfiles-windows"; `
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; `
Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/$($GitHubRepositoryAuthor)/$($GitHubRepositoryName)/main/Download.ps1");
```

The `Download.ps1` script will download and copy the files to your `${HOME}\.dotfiles` directory. Then, the `Setup.ps1` script will be launched automatically, which is responsible for configuring the machine.

> **Note**
> You must have your execution policy set to Unrestricted (or at least in Bypass) for this to work _(As a developer, you will need it anyway)_.

## Configuration

First, the user will be asked if they want to execute each option separately. Then, a `config.json` is created containing the selected settings[^1]. Finally, by giving permission to run, the script will execute according to them, giving you time to do anything else.

[^1]: The option of loading or creating a new configuration file will be given if there is already one in the directory.

### Options

You will be given the option to select which source to use if there are multiple sources.

#### Applications

- Basic tools installation
  - [7-Zip](https://www.7-zip.org)
  - [Fluent Search](https://fluentsearch.net) _(winget, msstore)_
  - [PowerToys](https://docs.microsoft.com/en-us/windows/powertoys) _(winget, msstore)_
  - [ShareX](https://getsharex.com) _(winget, msstore)_
  - [SnipDo](https://snipdo-app.com) _(msstore)_
  - [SumatraPDF](https://www.sumatrapdfreader.org)
  - [Sysinternals](https://docs.microsoft.com/en-us/sysinternals) _(msstore)_
  - [VLC](https://www.7-zip.org)
  - [WinSCP](https://winscp.net)
- DevOps tools installation
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - [AWS CLI](https://aws.amazon.com/cli)
  - [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
  - [MobaXterm](https://mobaxterm.mobatek.net)
- [Espanso](https://espanso.org)
  - Custom matches
- [Git](https://git-scm.com)
  - Globals configuration _(`user.email`, `user.name`, and more)_
- [Visual Studio Code](https://code.visualstudio.com) _(winget, msstore)_
  - Extensions installation
  - Settings configuration
- [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal) _(winget, msstore)_
  - Settings configuration
    - Custom actions
    - Profile defaults

#### OS

- [Windows](https://www.microsoft.com/en-us/windows)
  - Configurations
    - Dark mode
      - Cursor
      - Theme
    - Explorer settings
      - Show file extensions
      - Show hidden files
      - Turn off Windows Narrator hotkey
    - Power plan settings
      - AC timeout
    - Privacy settings
      - Deny Microsoft Store applications access
      - Deny personalized advertisements
    - Regional formats
      - Date
      - FirstDayOfWeek
      - Time
    - Rename computer
  - Directories
    - 'Workspace' directory configuration
  - Fonts
    - [Nerd Font](https://www.nerdfonts.com)
      - Default font for Windows Terminal

#### Shell

- [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting) _(winget, <span style="color: red">msstore - currently broken; issue: [#9278](https://github.com/PowerShell/PowerShell/issues/9278)</span>)_
  - `$PROFILE` configuration
    - _Optional: Removing selected sections not to be installed_
  - Modules installation
    - [posh-git](https://github.com/dahlbyk/posh-git)
    - [PSWebSearch](https://github.com/JMOrbegoso/PSWebSearch)
    - [PSReadLine](https://github.com/PowerShell/PSReadLine)
    - [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
    - [z](https://www.powershellgallery.com/packages/z)
  - [Oh My Posh](https://ohmyposh.dev/docs)
    - Using [`powerlevel10k_classic`](https://ohmyposh.dev/docs/themes#powerlevel10k_classic) theme

## Feedback

Suggestions/improvements are
[welcome and encouraged](https://github.com/E-RELevant/dotfiles-windows/issues).
