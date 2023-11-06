#!/bin/bash
cd /sdcard/Pictures/
# Start watching
while : ;do
	tree -ifl ./ | grep -E "\/[Ss]creenshot" | grep -E "\.[Jj][Pp][Gg]$" | while IFS= read -r file; do
		success=0
		# Encode WebP
		if [ -e "$(which cwebp)" ]; then
			echo "Encoding '${file}' to WebP..."
			cwebp -m 5 -psnr 56 "${file}" -o "${file/.jpg/.webp}" -quiet && success=1
		fi
		# Encode JPEG XL
		if [ -e "$(which cjxl)" ]; then
			echo "Encoding '${file} to JPEG XL...'"
 			cjxl -d 1.1 -e 4 -p "${file}" "${file/.jpg/.jxl}" && success=1
		fi
		if [ "${success}" == "1" ]; then
			rm -v "${file}"
		fi
	done
done
exit
