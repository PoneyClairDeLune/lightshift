#!/bin/bash
cd /sdcard/Pictures/
# Start watching
while : ;do
	tree -ifl ./ | grep -E "/[Ss]creenshot" | grep -E "\.jpg$" | while IFS= read -r file; do
		success=0
		neatFile="$file"
		if [[ "$neatFile" == *"_"* ]]; then
			neatFile="$(echo $file| cut -d'_' -f1,2).jpg"
			echo "Cleaned file name from '${file}' to '${neatFile}'."
		fi
		# Encode WebP
		if [ -e "$(which cwebp)" ]; then
			echo "Encoding '${file}' to WebP..."
			cwebp -m 5 -psnr 56 "${file}" -o "${neatFile/.jpg/.webp}" -quiet && success=1
		fi
		# Encode JPEG XL
		if [ -e "$(which cjxl)" ]; then
			echo "Encoding '${file} to JPEG XL...'"
 			cjxl -d 1.1 -e 4 -p "${file}" "${neatFile/.jpg/.jxl}" --container 0 -j 0 && success=1
		fi
		if [ "${success}" == "1" ]; then
			rm -v "${file}"
		fi
	done
	sleep 1s
done
exit
