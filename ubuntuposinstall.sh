#!/bin/bash
# Script de pós-instalação para Ubuntu 24.04 LTS - Noble Numbat
# Autor: ctfcarlostorres@hotmail.com

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root (sudo)."
  exit
fi

clear
echo "============================================================"
echo "   Pós-instalação do Ubuntu 24.04 LTS - Noble Numbat"
echo "============================================================"
sleep 2

# Funções de tempo e progresso
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

# Estimativas de tempo por categoria (em segundos)
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
tempo_otimizacoes=90
tempo_comunicacao=90
tempo_jogos=90

total_estimado=0
total_real=0

# Pré-visualização de pacotes por categoria
preview_basicos() { echo "Pacotes básicos: git, vim, neovim, aptitude, htop, timeshift"; }
preview_multimidia() { echo "Multimídia: VLC, MPV, Kdenlive, Shotcut, Audacity, OBS Studio, Spotify, etc."; }
preview_grafico() { echo "Gráfico: GIMP, Inkscape, Blender, Krita, Scribus, SynfigStudio, etc."; }
preview_cientifico() { echo "Científico: Octave, Scilab, Gnuplot, GeoGebra, FreeCAD, Stellarium, etc."; }
preview_produtividade() { echo "Produtividade: LibreOffice, Abiword, Calibre, Planner, Dia, Cherrytree, etc."; }
preview_internet() { echo "Internet: Filezilla, qBittorrent, Uget, Thunderbird, Pidgin, Gajim, etc."; }
preview_utilitarios() { echo "Utilitários: Stacer, Bleachbit, GParted, Psensor, Inxi, Hardinfo, etc."; }
preview_virtualizacao() { echo "Virtualização: virt-manager, libvirt"; }
preview_manutencao() { echo "Manutenção: autoremove, autoclean, clean, deborphan, cron"; }
preview_integridade() { echo "Integridade: apt-get check, dpkg, debsums"; }
preview_hd() { echo "Disco/Hardware: smartctl, fsck, hddtemp"; }
preview_backup() { echo "Backup com Timeshift: snapshot diário"; }
preview_restore() { echo "Restauração manual com Timeshift"; }
preview_restore_agendado() { echo "Restauração agendada com Timeshift via cron"; }
preview_otimizacoes() { echo "Otimizações: Flatpak, TLP, GNOME ajustes, temas, fontes, sysctl.conf, ufw"; }
preview_comunicacao() { echo "Navegadores e comunicação: Discord, Telegram, Chrome, Edge, AnyDesk, Synaptic"; }
preview_jogos() { echo "Jogos e emuladores: Steam, Lutris, Dolphin, Ryujinx, PCSX2, etc."; }

# Exemplo de função de instalação (básicos)
instalar_basicos() {
  timer apt update
  timer apt install -y git neovim vim vim-gtk3 aptitude htop timeshift
  progress_bar 8
}

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
echo "16) Configuração e otimização do sistema"
echo "17) Navegadores e comunicação"
echo "18) Jogos e emuladores"
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
    9) for i in {1..8}; do
         preview_func="preview_$(echo ${i} | awk '{print ($1==1?"basicos":$1==2?"multimidia":$1==3?"grafico":$1==4?"cientifico":$1==5?"produtividade":$1==6?"internet":$1==7?"utilitarios":"virtualizacao") }')"
         instalar_func="instalar_$(echo ${i} | awk '{print ($1==1?"basicos":$1==2?"multimidia":$1==3?"grafico":$1==4?"cientifico":$1==5?"produtividade":$1==6?"internet":$1==7?"utilitarios":"virtualizacao") }')"
         $preview_func | tee -a "$relatorio"
         total_estimado=$((total_estimado + tempo_basicos))
         $instalar_func
       done ;;
    10) preview_manutencao | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_manutencao)); instalar_manutencao ;;
    11) preview_integridade | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_integridade)); verificar_integridade ;;
    12) preview_hd | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_hd)); verificar_hd ;;
    13) preview_backup | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_backup)); executar_backup ;;
    14) preview_restore | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_restore)); executar_restore ;;
    15) preview_restore_agendado | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_restore_agendado)); executar_restore_agendado ;;
    16) preview_otimizacoes | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_otimizacoes)); instalar_otimizacoes ;;
    17) preview_comunicacao | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_comunicacao)); instalar_comunicacao ;;
    18) preview_jogos | tee -a "$relatorio"; total_estimado=$((total_estimado + tempo_jogos)); instalar_jogos ;;
    0) echo "Saindo..."; exit 0 ;;
    *) echo "Opção inválida: $opcao" ;;
  esac
done

# Conversão de tempos e finalização
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





