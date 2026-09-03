#!/system/bin/sh
.
LOCALANIM="$MODPATH/system/product/media"
PACK="$MODPATH/pack"
ZIP="$MODPATH/bin/zip"

RES=$(wm size 2>/dev/null | grep -oE '[0-9]+x[0-9]+')

if [ -z "$RES" ]; then
    RES=$(dumpsys display 2>/dev/null | grep -oE 'mBaseDisplayInfo=.*Width=[0-9]+, Height=[0-9]+' | grep -oE '[0-9]+' | tr '\n' 'x' | sed 's/x$//')
fi

LARG=$(echo "$RES" | cut -d 'x' -f1)
ALT=$(echo "$RES" | cut -d 'x' -f2)

[ -z "$LARG" ] && LARG=720
[ -z "$ALT" ] && ALT=1280

ui_print "[+] Resolução detectada para desc.txt: ${LARG}x${ALT}"

ui_print "[+] Criando desc.txt dinâmico..."
cat << EOF > "$PACK/desc.txt"
$LARG $ALT 60
c 1 0 part0
c 0 0 part1
c 1 0 part2
EOF

ui_print "[+] Configurando permissões do binário zip..."
chmod 755 "$ZIP"

ui_print "[+] Criando diretórios do sistema no módulo..."
mkdir -p "$LOCALANIM"

ui_print "[+] Compactando bootanimation.zip (Compressão 0)..."
cd "$PACK" || exit 1
"$ZIP" -0r "$LOCALANIM/bootanimation.zip" ./*

ui_print "[+] Criando link simbólico para o modo escuro..."
ln -sf "bootanimation.zip" "$LOCALANIM/bootanimation-dark.zip"

chmod 644 "$LOCALANIM"/bootanimation*.zip

rm -rf "$PACK"
ui_print "[+] Removendo pack de empacotamento"
ui_print "[✔] Tudo pronto! Kali Glitch gerado com sucesso."

