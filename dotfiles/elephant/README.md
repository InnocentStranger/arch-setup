# Elephant (Backend for walker)

### Pre-requisite
- `Install **go**`
    
```sh 
    sudo pacman -S go
```

### Install From Source

```sh
# Clone the repository
git clone https://github.com/abenz1267/elephant
cd elephant

# Build and install the main binary
cd cmd/elephant
go install elephant.go

sudo mv ~/go/bin/elephant /usr/local/bin/

# Create configuration directories
mkdir -p ~/.config/elephant/providers

# Build and install a provider (example: desktop applications)
cd ../../internal/providers/desktopapplications
go build -buildmode=plugin
cp desktopapplications.so ~/.config/elephant/providers/

# Build and install a provider (example: Files)
cd ../files
go build -buildmode=plugin
cp files.so ~/.config/elephant/providers/
```

### Generate Systemd Service

```sh
elephant service enable
systemctl --user daemon-reload
systemctl --user enable --now elephant.service
```
