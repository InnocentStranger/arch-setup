# Fresh Arch Install

### Usefull Packages
```sh
sudo pacman -S tmux neovim tree-sitter-cli tar curl ripgrep nvm starship ttf-jetbrains-mono-nerd chromium spotify-launcher vesktop stow kitty obs-studio vscodium lazygit openbsd-netcat
```

### Refresh Font Cache
```sh
fc-cache -fv
```

### Change System Locale

Follow these steps to configure and set your system's locale.

#### 1. Uncomment Required Locales
Open the locale configuration file to select your desired languages:

```sh
sudo vim /etc/locale.gen
```

Scroll through the file and locate the locales you want to enable (for example, `en_US.UTF-8 UTF-8`). Remove the `#` at the beginning of the line to uncomment it. Save and exit the file.

#### 2. Generate the Locales
Compile the newly selected locales so the system can use them:

```sh
sudo locale-gen
```

#### 3. Set the System Locale
You can set your primary system language using **Option A** (recommended) or **Option B**.

*   **Option A: Using localectl (Recommended)**
    Run the following command to automatically update your system configuration:
    
    ```sh
    sudo localectl set-locale LANG=en_US.UTF-8
    ```

*   **Option B: Manual Configuration**
    Open the locale configuration file manually:
    
    ```sh
    sudo vim /etc/locale.conf
    ```
    
    Add or update the `LANG` variable to match your chosen locale:
    
    LANG=en_US.UTF-8

#### 4. Apply Changes
For the changes to take effect across your entire desktop environment and user session, log out of your system and log back in, or reboot

