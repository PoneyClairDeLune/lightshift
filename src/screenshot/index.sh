#!/bin/bash
cd /sdcard/Pictures/
# Force installing certain dependencies
which echo 2>/dev/null 1>/dev/null
if [ "$?" != "0" ]; then
	apt install which -y
fi
if [ ! -e "$(which tree)" ]; then
	apt install tree -y
fi
if [ ! -e "$(which cjxl)" ]; then
	apt install libjxl-progs -y
fi
# Start watching
echo "Screenshot metadata remover has started."
while : ; do
	tree -ifl ./ | grep -E "/[Ss]creenshot" | grep -E "\.jpg$" | while IFS= read -r file; do
		success=0
		neatFile="$file"
		if [[ "$neatFile" == S*"-"*"_"* ]]; then
			# Use S filename cleanup strategy
			neatFile="$(echo $file| cut -d'_' -f1).jpg"
			echo "Cleaned file name to '${neatFile}' with S strategy."
		elif [[ "$neatFile" == *"_"*"_"* ]]; then
			# Use default filename cleanup strategy
			neatFile="$(echo $file| cut -d'_' -f1,2).jpg"
			echo "Cleaned file name to '${neatFile}' with default strategy."
		fi
		if [ -e "$(which cjxl)" ]; then
			# Encode JPEG XL
			echo "Encoding '${file} to JPEG XL...'"
 			cjxl -d 1.1 -e 4 -p "${file}" "${neatFile/.jpg/.jxl}" --container 0 -j 0 && success=1
			djxl "${neatFile/.jpg/.jxl}" "${neatFile/.jpg/.jpeg}"
		elif [ -e "$(which cwebp)" ]; then
			# Encode WebP
			echo "Encoding '${file}' to WebP..."
			cwebp -m 5 -psnr 56 "${file}" -o "${neatFile/.jpg/.webp}" -quiet && success=1
		elif [ -e "$(which cjpeg)" ]; then
			# Just re-encode JPEG
			cjpeg -quality 95 -progressive -optimize "${file}" -outfile "${neatFile/.jpg/.jpeg}"
		fi
		fi
		if [ "${success}" == "1" ]; then
			rm -v "${file}"
		fi
	done
	sleep 1s
done
exit
