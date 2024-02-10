function Install-VSCodeExtensions() {

    <#
    .SYNOPSIS
    Installs frequently used Visual Studio Code extensions.

    .INPUTS
    None. You cannot pipe objects to Install-VSCodeExtensions.

    .OUTPUTS
    None.
    #>

    Write-Host "Installing Visual Studio Code extensions:" -ForegroundColor "Yellow"

    # Formatting and Rules
    code --install-extension "aaron-bond.better-comments"
    code --install-extension "esbenp.prettier-vscode"
    code --install-extension "streetsidesoftware.code-spell-checker"

    # Tools
    code --install-extension "ritwickdey.LiveServer"
    code --install-extension "tabnine.tabnine-vscode"

    # IDE Themes
    code --install-extension "PKief.material-icon-theme"
    code --install-extension "zhuangtongfa.material-theme"

    # HTML and CSS
    code --install-extension "ecmel.vscode-html-css"
    code --install-extension "formulahendry.auto-rename-tag"
    code --install-extension "pranaygp.vscode-css-peek"

    # Markdown
    code --install-extension "bierner.github-markdown-preview"
    code --install-extension "davidanson.vscode-markdownlint"
    code --install-extension "robole.markdown-snippets"
    code --install-extension "yzhang.markdown-all-in-one"

    # Terraform
    code --install-extension "hashicorp.terraform"

    # PowerShell
    code --install-extension "ms-vscode.powershell"
    
    # YAML
    code --install-extension "redhat.vscode-yaml"

    Write-Host "Visual Studio Code extensions have been successfully installed.`n" -ForegroundColor "Green"
}
