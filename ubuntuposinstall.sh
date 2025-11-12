#!/bin/bash
# Script de pós-instalação modular para Ubuntu 24.04 LTS Noble Numbat
# Autor: ctfcarlostorres@hotmail.com
# Funcionalidades:
# - Instalação modular por categorias (originais + novas)
# - Pré-visualização com descrições
# - Relatório de instalação
# - Tempo estimado e real (minutos e segundos)
# - Manutenção e limpeza
# - Verificação de integridade
# - Diagnóstico de disco e hardware
# - Backup e restauração com Timeshift (manual e agendada)
# - Tela de abertura personalizada
# - Link final para blog

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root (sudo)."
  exit
fi

# ---------------------------
# Tela de abertura
# ---------------------------
clear
echo "============================================================"
echo "   ____        _        _        _             _            "
echo "  |  _ \\  ___ | |_ __ _| |_ ___ | | ___   __ _(_)_ __   ___ "
echo "  | | | |/ _ \\| __/ _\` | __/ _ \\| |/ _ \\ / _\` | | '_ \\ / _ \\"
echo "  | |_| | (_) | || (_| | || (_) | | (_) | (_| | | | | |  __/"
echo "  |____/ \\___/ \\__\\__,_|\\__\\___/|_|\\___/ \\__, |_|_| |_|\\___|"
echo "                                        |___/               "
echo "============================================================"
echo "   Pós instalação do Ubuntu by ctfcarlostorres@hotmail.com   "
echo "============================================================"
sleep 2

# ---------------------------
# Funções de tempo e progresso
# ---------------------------
timer() {
  local start=$(date +%s)
  "$@"
  local end=$(date +%s)
  local runtime=$((end - start))
  echo "⏱ Tempo gasto: $runtime segundos"
  total_real=$((total_real + runtime))
}

progress_bar() {
  local duration=$1
  local interval=1
  local count=0
  while [ $count -lt $duration ]; do
    count=$((count + interval))
    percent=$((count * 100 / duration))
    echo -ne "Progresso: ["
    for ((i=0; i<percent/5; i++)); do echo -ne "#"; done
    for ((i=percent/5; i<20; i++)); do echo -ne " "; done
    echo -ne "] $percent% \r"
    sleep $interval
  done
  echo
}

# ---------------------------
# Estimativas de tempo por categoria (em segundos)
# ---------------------------
tempo_basicos=60
tempo_multimidia=120
tempo_grafico=120
tempo_cientifico=90
tempo_produtividade=90
tempo_internet=60
tempo_utilitarios=60
tempo_virtualizacao=45
tempo_manutencao=40
tempo_integridade=40
tempo_hd=40
tempo_backup=60
tempo_restore=60
tempo_restore_agendado=60

# Novas categorias (estimativas)
tempo_gnome=40
tempo_firewall=40
tempo_memoria=30
tempo_energia=40
tempo_flatpak=40
tempo_codecs=120
tempo_cad=120
tempo_apps=150
tempo_jogos=120
tempo_compactadores=90
tempo_anydesk=60

total_estimado=0
total_real=0

# ---------------------------
# Pré-visualização de pacotes com descrição (originais)
# ---------------------------
preview_basicos() { echo "Pacotes básicos: git, vim/neovim, aptitude, htop, timeshift"; }
preview_multimidia() { echo "Multimídia: VLC, MPV, Kdenlive, Shotcut, Audacity, Ardour, LMMS, Mixxx, MuseScore"; }
preview_grafico() { echo "Gráfico: GIMP, Inkscape, Blender, Krita, Darktable, RawTherapee, Digikam, LibreCAD, SolveSpace"; }
preview_cientifico() { echo "Científico: Octave, Scilab, Gnuplot, GeoGebra, KiCad, Electric, Stellarium"; }
preview_produtividade() { echo "Produtividade: LibreOffice, Abiword, Gnumeric, Calibre, Planner, Dia, Cherrytree, KeePassXC"; }
preview_internet() { echo "Internet: Filezilla, qBittorrent, Transmission, Uget, youtube-dl, Pidgin, Gajim, KDEConnect"; }
preview_utilitarios() { echo "Utilitários: Stacer, Bleachbit, CPU-X, Inxi, Hardinfo, Psensor, Smartmontools, Samba, cifs-utils"; }
preview_virtualizacao() { echo "Virtualização: virt-manager (libvirt)"; }
preview_manutencao() { echo "Manutenção: autoremove, autoclean, clean, deborphan, agendamento via cron (opcional)"; }
preview_integridade() { echo "Integridade: apt-get check, dpkg --configure -a, apt-get -f install, debsums -s"; }
preview_hd() { echo "Disco/Hardware: smartctl -H/-A, fsck -n, hddtemp"; }
preview_backup() { echo "Backup com Timeshift: cria snapshot (tag diária)"; }
preview_restore() { echo "Restauração com Timeshift: escolher snapshot e restaurar"; }
preview_restore_agendado() { echo "Restauração agendada com Timeshift: cron semanal do snapshot escolhido"; }

# ---------------------------
# Pré-visualização de novas categorias
# ---------------------------
preview_gnome() { echo "GNOME: gnome-software, gnome-tweaks + ajuste Dash-to-Dock (minimize ao clicar)"; }
preview_firewall() { echo "Firewall: ufw, gufw + ativação automática do UFW"; }
preview_memoria() { echo "Memória: ajustes no /etc/sysctl.conf (swappiness, vfs_cache_pressure, dirty bytes)"; }
preview_energia() { echo "Energia: TLP (tlp, tlp-rdw), habilitar serviço e iniciar"; }
preview_flatpak() { echo "Flatpak: flatpak, plugin do GNOME e repositório Flathub"; }
preview_codecs() { echo "Codecs/Fontes/Temas: ffmpeg, gstreamer, lame, MS fonts, ImageMagick, temas/estilos LibreOffice"; }
preview_cad() { echo "CAD: librecad, leocad e FreeCAD (via PPA estável)"; }
preview_apps() { echo "Apps: Discord (deb), Telegram (snap), Google Chrome (deb), Microsoft Edge (repo oficial)"; }
preview_jogos() { echo "Jogos: Steam, Lutris + emuladores via Flatpak (Dolphin, Lime3DS, Flycast, PCSX2, RPCS3, etc.)"; }
preview_compactadores() { echo "Compactadores/Utilitários: arc, arj, rar/unrar, zip, p7zip, gdebi, gparted, synaptic, Warehouse (Flatpak)"; }
preview_anydesk() { echo "AnyDesk: chave e repositório oficial + instalação"; }

# ---------------------------
# Funções de instalação e manutenção (originais)
# ---------------------------
instalar_basicos() {
  timer apt update
  timer apt install -y git neovim vim vim-gtk3 aptitude htop timeshift apturl apturl-common build-essential dkms
  progress_bar 8
}

instalar_multimidia() {
  timer apt install -y vlc mpv smplayer kdenlive shotcut openshot-qt audacity ardour qtractor lmms mixxx musescore \
    ubuntu-restricted-extras audacious libqt6svg6 kodi blender gimp handbrake inkscape krita krita-l10n obs-studio rawtherapee digikam darktable
  progress_bar 12
}

instalar_grafico() {
  timer apt install -y gimp inkscape blender krita darktable rawtherapee digikam librecad solvespace
  progress_bar 12
}

instalar_cientifico() {
  timer apt install -y octave scilab gnuplot geogebra kicad electric stellarium
  progress_bar 10
}

instalar_produtividade() {
  timer apt install -y libreoffice abiword gnumeric calibre planner dia cherrytree keepassxc
  progress_bar 10
}

instalar_internet() {
  timer apt install -y filezilla qbittorrent transmission-gtk uget youtube-dl pidgin gajim kdeconnect
  progress_bar 9
}

instalar_utilitarios() {
  timer apt install -y stacer bleachbit cpu-x inxi hardinfo psensor smartmontools samba cifs-utils
  progress_bar 9
}

instalar_virtualizacao() {
  timer apt install -y virt-manager
  adduser "$SUDO_USER" libvirt 2>/dev/null || true
  progress_bar 6
}

instalar_manutencao() {
  echo "=== Manutenção e limpeza ==="
  timer apt-get autoremove -y
  timer apt-get autoclean -y
  timer apt-get clean -y
  if ! command -v deborphan >/dev/null 2>&1; then
    timer apt install -y deborphan
  fi
  ORFAOS=$(deborphan)
  if [ -n "$ORFAOS" ]; then
    echo "$ORFAOS" | xargs apt-get -y remove --purge
  else
    echo "Nenhum pacote órfão encontrado."
  fi
  progress_bar 8

  read -p "Agendar manutenção semanal? (s/n): " resp
  if [[ "$resp" == "s" || "$resp" == "S" ]]; then
    read -p "Dia da semana (0=domingo...6=sábado): " dia
    read -p "Hora (0-23): " hora
    read -p "Minuto (0-59): " minuto
    (crontab -l 2>/dev/null; echo "$minuto $hora * * $dia apt-get autoremove -y && apt-get autoclean -y && apt-get clean -y") | crontab -
    echo "⏳ Manutenção semanal agendada para $hora:$minuto no dia $dia."
  fi
}

verificar_integridade() {
  echo "=== Verificação de integridade ==="
  timer apt-get check
  timer dpkg --configure -a
  timer apt-get -f install -y
  if ! command -v debsums >/dev/null 2>&1; then
    timer apt install -y debsums
  fi
  timer debsums -s
  progress_bar 8
}

verificar_hd() {
  echo "=== Verificação de disco e hardware ==="
  if ! command -v smartctl >/dev/null 2>&1; then
    timer apt install -y smartmontools
  fi
  timer smartctl -H /dev/sda
  timer smartctl -A /dev/sda
  timer fsck -n /dev/sda1
  if ! command -v hddtemp >/dev/null 2>&1; then
    timer apt install -y hddtemp
  fi
  timer hddtemp /dev/sda
  progress_bar 8
}

executar_backup() {
  echo "=== Backup com Timeshift ==="
  timer apt install -y timeshift
  if ! timeshift --list >/dev/null 2>&1; then
    echo "Configurando Timeshift rapidamente (pode requerer interação futura pelo GUI)."
  fi
  timer timeshift --create --comments "Backup automático" --tags D
  progress_bar 12
}

executar_restore() {
  echo "=== Restauração com Timeshift ==="
  timer apt install -y timeshift
  timeshift --list
  read -p "Digite o snapshot para restaurar (ID exato): " snapshot
  timer timeshift --restore --snapshot "$snapshot" --yes
  progress_bar 15
}

executar_restore_agendado() {
  echo "=== Restauração agendada com Timeshift ==="
  timer apt install -y timeshift
  timeshift --list
  read -p "Digite o snapshot para restaurar automaticamente (ID exato): " snapshot
  read -p "Dia da semana (0=domingo...6=sábado): " dia
  read -p "Hora (0-23): " hora
  read -p "Minuto (0-59): " minuto
  (crontab -l 2>/dev/null; echo "$minuto $hora * * $dia timeshift --restore --snapshot $snapshot --yes") | crontab -
  echo "⏳ Restauração agendada para $hora:$minuto no dia $dia."
}

# ---------------------------
# Funções de instalação das novas categorias
# ---------------------------
instalar_gnome() {
  timer apt install -y gnome-software gnome-tweaks
  # Ajuste do Dash-to-Dock (minimizar ao clicar)
  gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize' || true
  progress_bar 6
}

instalar_firewall() {
  timer apt install -y ufw gufw
  timer ufw enable
  progress_bar 6
}

instalar_memoria() {
  echo "=== Ajustes de memória (sysctl.conf) ==="
  # Evita duplicações: só adiciona se as linhas não existirem
  grep -q "^vm.swappiness=10" /etc/sysctl.conf || echo "vm.swappiness=10" >> /etc/sysctl.conf
  grep -q "^vm.vfs_cache_pressure=50" /etc/sysctl.conf || echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
  grep -q "^vm.dirty_background_bytes=16777216" /etc/sysctl.conf || echo "vm.dirty_background_bytes=16777216" >> /etc/sysctl.conf
  grep -q "^vm.dirty_bytes=50331648" /etc/sysctl.conf || echo "vm.dirty_bytes=50331648" >> /etc/sysctl.conf
  sysctl -p || true
  progress_bar 5
}

instalar_energia() {
  timer apt install -y tlp tlp-rdw
  timer systemctl enable tlp.service
  timer tlp start
  progress_bar 6
}

instalar_flatpak() {
  timer apt install -y flatpak gnome-software-plugin-flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  progress_bar 6
}

instalar_codecs() {
  timer apt install -y faad ffmpeg gstreamer1.0-libav gstreamer1.0-vaapi \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly lame libavcodec-extra sox twolame vorbis-tools \
    ttf-mscorefonts-installer fonts-hack-ttf imagemagick materia-gtk-theme \
    deepin-icon-theme paper-icon-theme libreoffice-l10n-pt-br \
    libreoffice-style-breeze libreoffice-style-colibre libreoffice-style-elementary \
    libreoffice-style-hicontrast libreoffice-style-sifr
  progress_bar 12
}

instalar_cad() {
  timer apt install -y librecad leocad
  add-apt-repository -y ppa:freecad-maintainers/freecad-stable
  apt update
  timer apt install -y freecad freecad-doc
  progress_bar 10
}

instalar_apps() {
  # Discord
  cd /tmp && wget -O discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
  timer apt install -y ./discord.deb && cd "$HOME"
  # Telegram
  timer snap install telegram-desktop
  # Google Chrome
  cd /tmp && wget -O google-chrome-stable.deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'
  timer apt install -y ./google-chrome-stable.deb && cd "$HOME"
  # Microsoft Edge
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge/ stable main" | tee /etc/apt/sources.list.d/microsoft-edge.list
  timer apt install -y curl
  cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  cd "$HOME"
  apt update
  timer apt install -y microsoft-edge-stable
  progress_bar 15
}

instalar_jogos() {
  timer apt install -y steam lutris
  flatpak install -y flathub org.DolphinEmu.dolphin-emu io.github.lime3ds.Lime3DS \
    org.flycast.Flycast net.pcsx2.PCSX2 net.rpcs3.RPCS3 com.snes9x.Snes9x io.mgba.mGBA \
    app.xemu.xemu org.ryujinx.Ryujinx
  progress_bar 15
}

instalar_compactadores() {
  timer apt install -y arc arj cabextract lhasa p7zip p7zip-full p7zip-rar rar unrar \
    unace unzip xz-utils zip gdebi stacer uget qbittorrent gparted synaptic
  flatpak install -y flathub io.github.flattool.Warehouse
  progress_bar 12
}

instalar_anydesk() {
  cd /tmp && wget -qO- https://keys.anydesk.com/repos/DEB-GPG-KEY | gpg --dearmor -o /etc/apt/trusted.gpg.d/anydesk.gpg
  cd "$HOME"
  echo "deb http://deb.anydesk.com/ all main" | tee /etc/apt/sources.list.d/anydesk-stable.list
  apt update
  timer apt install -y anydesk
  progress_bar 8
}

# ---------------------------
# Menu interativo
# ---------------------------
echo "=== Escolha as categorias que deseja instalar/manter ==="
echo "1) Pacotes básicos"
echo "2) Multimídia"
echo "3) Gráfico"
echo "4) Científico"
echo "5) Produtividade"
echo "6) Internet"
echo "7) Utilitários extras"
echo "8) Virtualização"
echo "9) Todas as categorias (1–8)"
echo "10) Manutenção e limpeza"
echo "11) Verificação de integridade"
echo "12) Verificação de disco e hardware"
echo "13) Backup automático com Timeshift"
echo "14) Restauração manual com Timeshift"
echo "15) Restauração agendada com Timeshift"
echo "16) GNOME"
echo "17) Firewall"
echo "18) Ajustes de memória"
echo "19) Energia (TLP)"
echo "20) Flatpak"
echo "21) Codecs e fontes"
echo "22) CAD"
echo "23) Apps extras (Discord, Telegram, Chrome, Edge)"
echo "24) Jogos"
echo "25) Compactadores e utilitários"
echo "26) AnyDesk"
echo "0) Sair"

read -p "Digite os números das opções desejadas (ex: 1 3 5 ou 9 para todas): " escolhas

relatorio="relatorio_instalacao.txt"
echo "Relatório de instalação - $(date)" > "$relatorio"

for opcao in $escolhas; do
  case $opcao in
    1) preview_basicos | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_basicos)); instalar_basicos ;;
    2) preview_multimidia | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_multimidia)); instalar_multimidia ;;
    3) preview_grafico | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_grafico)); instalar_grafico ;;
    4) preview_cientifico | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_cientifico)); instalar_cientifico ;;
    5) preview_produtividade | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_produtividade)); instalar_produtividade ;;
    6) preview_internet | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_internet)); instalar_internet ;;
    7) preview_utilitarios | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_utilitarios)); instalar_utilitarios ;;
    8) preview_virtualizacao | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_virtualizacao)); instalar_virtualizacao ;;
    9) preview_basicos | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_basicos)); instalar_basicos;
       preview_multimidia | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_multimidia)); instalar_multimidia;
       preview_grafico | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_grafico)); instalar_grafico;
       preview_cientifico | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_cientifico)); instalar_cientifico;
       preview_produtividade | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_produtividade)); instalar_produtividade;
       preview_internet | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_internet)); instalar_internet;
       preview_utilitarios | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_utilitarios)); instalar_utilitarios;
       preview_virtualizacao | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_virtualizacao)); instalar_virtualizacao ;;
    10) preview_manutencao | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_manutencao)); instalar_manutencao ;;
    11) preview_integridade | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_integridade)); verificar_integridade ;;
    12) preview_hd | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_hd)); verificar_hd ;;
    13) preview_backup | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_backup)); executar_backup ;;
    14) preview_restore | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_restore)); executar_restore ;;
    15) preview_restore_agendado | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_restore_agendado)); executar_restore_agendado ;;
    16) preview_gnome | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_gnome)); instalar_gnome ;;
    17) preview_firewall | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_firewall)); instalar_firewall ;;
    18) preview_memoria | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_memoria)); instalar_memoria ;;
    19) preview_energia | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_energia)); instalar_energia ;;
    20) preview_flatpak | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_flatpak)); instalar_flatpak ;;
    21) preview_codecs | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_codecs)); instalar_codecs ;;
    22) preview_cad | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_cad)); instalar_cad ;;
    23) preview_apps | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_apps)); instalar_apps ;;
    24) preview_jogos | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_jogos)); instalar_jogos ;;
    25) preview_compactadores | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_compactadores)); instalar_compactadores ;;
    26) preview_anydesk | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_anydesk)); instalar_anydesk ;;
    0) echo "Saindo..."; exit 0 ;;
    *) echo "Opção inválida: $opcao" ;;
  esac
done

# ---------------------------
# Conversão de tempos e finalização
# ---------------------------
estimado_min=$((total_estimado / 60))
estimado_seg=$((total_estimado % 60))
real_min=$((total_real / 60))
real_seg=$((total_real % 60))

echo "============================================================"
echo "✅ Execução concluída!"
echo "📄 Relatório salvo em: $relatorio"
echo "⏳ Tempo estimado total: ${estimado_min} min ${estimado_seg} seg"
echo "⏱ Tempo real total: ${real_min} min ${real_seg} seg"
echo "🌐 Para mais dicas e tutoriais, acesse: https://raidermx.blogspot.com.br"
echo "============================================================"
