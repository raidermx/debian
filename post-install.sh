
#!/usr/bin/env bash

# ==========================================================
# Debian - Script de Pos-Instalacao
# Compatibilidade: Debian 12 ou superior
# Arquiteturas: amd64 e arm64
# ==========================================================

set -u

VERSION="1.0"

if [[ $EUID -eq 0 ]]; then
    echo "Execute como usuario normal, sem sudo."
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "Este script requer uma distribuicao baseada em Debian."
    exit 1
fi

if [[ ! -f /etc/debian_version ]]; then
    echo "Distribuicao Debian nao identificada."
    exit 1
fi

ARCH=$(dpkg --print-architecture)

echo "======================================"
echo " Debian - Pos Instalacao $VERSION"
echo " Arquitetura: $ARCH"
echo "======================================"

# ----------------------------------------------------------
# PACOTES BASE
# ----------------------------------------------------------

BASE=(
    git curl wget aria2
    vim neovim mc tmux htop
    aptitude neofetch inxi
    cmatrix ncal ccal
    calc links2
    debsums deborphan
    hdparm ethtool
    zip unzip xz-utils
    p7zip-full
    unar cabextract
    rar unrar
    gparted
    gnome-disk-utility
    gnome-system-monitor
    baobab
    timeshift
    bleachbit
    smartmontools
    cpu-x
    psensor
    fonts-liberation
    fonts-hack-ttf
    ttf-mscorefonts-installer
)

# ----------------------------------------------------------
# INTERNET E REDE
# ----------------------------------------------------------

INTERNET=(
    firefox-esr
    thunderbird
    openssh-client
    openssh-server
    ssh
    filezilla
    qbittorrent
    transmission-gtk
    aria2
    openvpn
    network-manager-openvpn
    network-manager-openvpn-gnome
    samba
    smbclient
    cifs-utils
    flatpak
    gufw
)

# ----------------------------------------------------------
# MULTIMIDIA E GRAFICOS
# ----------------------------------------------------------

MULTIMEDIA=(
    gimp
    inkscape
    blender
    scribus
    krita
    vlc
    mpv
    smplayer
    audacity
    audacious
    obs-studio
    handbrake
    shotcut
    openshot-qt
    kdenlive
    darktable
    digikam
    mypaint
    rawtherapee
    flameshot
    cheese
    guvcview
    hydrogen
    lmms
    mixxx
    musescore
    ardour
    pitivi
    qtractor
    kodi
    ffmpeg
    gstreamer1.0-libav
    gstreamer1.0-plugins-bad
    gstreamer1.0-plugins-base
    gstreamer1.0-plugins-good
    gstreamer1.0-plugins-ugly
    lame
    vorbis-tools
)

# ----------------------------------------------------------
# CIENCIA E MATEMATICA
# ----------------------------------------------------------

CIENCIA=(
    octave
    scilab
    gnuplot
    geogebra
    qgis
    cantor
    stellarium
    kalgebra
    kalzium
    kmplot
    kig
    kbruch
    kgeography
    step
)

# ----------------------------------------------------------
# CAD E ENGENHARIA
# ----------------------------------------------------------

CAD=(
    librecad
    freecad
    leocad
    solvespace
    openscad
    kicad
    electric
)

# ----------------------------------------------------------
# DESENVOLVIMENTO
# ----------------------------------------------------------

DESENVOLVIMENTO=(
    build-essential
    gcc
    g++
    make
    cmake
    autoconf
    automake
    bison
    flex
    gfortran
    default-jdk
    python3
    python3-pip
    python3-venv
    ruby
    nodejs
    npm
    git
    emacs
    geany
    codeblocks
    bluefish
    lazarus
    sqlite3
)

# ----------------------------------------------------------
# VIRTUALIZACAO
# ----------------------------------------------------------

VIRTUALIZACAO=(
    virt-manager
    qemu-system
    qemu-utils
    libvirt-daemon-system
    libvirt-clients
    bridge-utils
)

# ----------------------------------------------------------
# SISTEMA E ADMINISTRACAO
# ----------------------------------------------------------

SISTEMA=(
    ufw
    gufw
    cockpit
    cockpit-bridge
    cockpit-system
    cockpit-networkmanager
    cockpit-packagekit
    cockpit-storaged
    tlp
    tlp-rdw
    unattended-upgrades
    systemd-zram-generator
    htop
    btop
    stacer
    gnome-tweaks
    gnome-system-monitor
    gnome-disk-utility
    network-manager
    curl
    wget
)

# ----------------------------------------------------------
# FUNCAO DE INSTALACAO
# ----------------------------------------------------------

install_packages() {

    local category="$1"
    shift

    local available=()
    local missing=()

    echo
    echo "======================================"
    echo " Instalando categoria: $category"
    echo "======================================"

    for package in "$@"; do

        if apt-cache show "$package" >/dev/null 2>&1; then
            available+=("$package")
        else
            missing+=("$package")
        fi

    done

    if ((${#available[@]})); then

        echo "Pacotes disponiveis: ${#available[@]}"

        sudo apt-get install -y "${available[@]}"

    fi

    if ((${#missing[@]})); then

        echo
        echo "Pacotes nao encontrados:"
        printf ' - %s\n' "${missing[@]}"

    fi
}

# ----------------------------------------------------------
# ATUALIZACAO
# ----------------------------------------------------------

echo
echo "Atualizando repositorios..."

sudo apt-get update

echo
echo "Atualizando sistema..."

sudo apt-get upgrade -y

# ----------------------------------------------------------
# SELECAO DE CATEGORIAS
# ----------------------------------------------------------

if (($# == 0)); then
    echo
    echo "Uso:"
    echo "$0 base"
    echo "$0 internet"
    echo "$0 multimedia"
    echo "$0 ciencia"
    echo "$0 cad"
    echo "$0 desenvolvimento"
    echo "$0 virtualizacao"
    echo "$0 sistema"
    echo "$0 all"
    exit 0
fi

for category in "$@"; do

    case "$category" in

        base)
            install_packages "Base" "${BASE[@]}"
            ;;

        internet)
            install_packages "Internet e Rede" "${INTERNET[@]}"
            ;;

        multimedia)
            install_packages "Multimidia" "${MULTIMEDIA[@]}"
            ;;

        ciencia)
            install_packages "Ciencia" "${CIENCIA[@]}"
            ;;

        cad)
            install_packages "CAD e Engenharia" "${CAD[@]}"
            ;;

        desenvolvimento)
            install_packages "Desenvolvimento" "${DESENVOLVIMENTO[@]}"
            ;;

        virtualizacao)
            install_packages "Virtualizacao" "${VIRTUALIZACAO[@]}"
            ;;

        sistema)
            install_packages "Sistema" "${SISTEMA[@]}"
            ;;

        all)
            install_packages "Base" "${BASE[@]}"
            install_packages "Internet" "${INTERNET[@]}"
            install_packages "Multimidia" "${MULTIMEDIA[@]}"
            install_packages "Ciencia" "${CIENCIA[@]}"
            install_packages "CAD" "${CAD[@]}"
            install_packages "Desenvolvimento" "${DESENVOLVIMENTO[@]}"
            install_packages "Virtualizacao" "${VIRTUALIZACAO[@]}"
            install_packages "Sistema" "${SISTEMA[@]}"
            ;;

        *)
            echo "Categoria desconhecida: $category"
            ;;

    esac

done

echo
echo "======================================"
echo " Instalacao finalizada!"
echo "======================================"

echo "Recomenda-se reiniciar o computador."
