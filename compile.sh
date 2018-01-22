#==========================================
# Compile script for NES Assembly on Linux
#==========================================
#
# Programmed by Bryan McClain
#

mainFile="Main"

wine NESASM3.exe "$mainFile.asm"

echo ""
echo "It is finished. Open file?"
echo "(N)estopia, (F)ceux, or (E)xit"

while true; do
read -rsn1 input
if [ "$input" = "n" ]; then
	echo Modify this file to open "Main.nes" with Nestopia
	break
fi

if [ "$input" = "f" ]; then
	echo Modify this file to open "Main.nes" with Fceux
	break
fi

if [ "$input" = "e" ]; then
	break
fi
done
