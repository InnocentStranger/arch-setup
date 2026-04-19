# Dotfiles Management with GNU Stow

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks for system configuration files. 

Base Paths Used:
* Source: ~/arch-setup/dotfiles
* Target: ~/ (Your Home Directory)

---

## 1. Stow (Apply / Update)
Use this to create symlinks for the first time or to apply newly added files. Note: Standard stow does not remove dead symlinks if you delete a file in the source repository.

Apply ALL packages:
  stow -v -d ~/arch-setup/dotfiles -t ~/ --ignore='.*\.md' */

Apply a SPECIFIC package (e.g., dunst):
  stow -v -d ~/arch-setup/dotfiles -t ~/ --ignore='.*\.md' dunst

---

## 2. Restow (Sync / Clean / Refresh)
Use this when you have deleted or renamed a file inside your dotfiles repository. Restow (-R) automatically unstows and then restows the package, effectively cleaning up dead symlinks in your home directory and applying the fresh state.

Restow ALL packages:
  stow -v -R -d ~/arch-setup/dotfiles -t ~/ --ignore='.*\.md' */

Restow a SPECIFIC package (e.g., dunst):
  stow -v -R -d ~/arch-setup/dotfiles -t ~/ --ignore='.*\.md' dunst

---

## 3. Delete (Unstow / Remove)
Use this to cleanly remove the symlinks from your home directory. This does not delete the actual configuration files in your ~/arch-setup/dotfiles repository; it only removes the links pointing to them.

Unstow ALL packages:
  stow -v -D -d ~/arch-setup/dotfiles -t ~/ --ignore='.*\.md' */

Unstow a SPECIFIC package (e.g., dunst):
  stow -v -D -d ~/arch-setup/dotfiles -t ~/ --ignore='.*\.md' dunst

---

### Command Flag Reference
* -v: Verbose output (shows exactly what is being symlinked or removed).
* -d: Sets the Stow directory (source).
* -t: Sets the target directory (where the symlinks go).
* -R: Restow (unstow then stow).
* -D: Delete (unstow).
* --ignore='.*\.md': Prevents markdown files (like this README) from being symlinked into the target directory.
