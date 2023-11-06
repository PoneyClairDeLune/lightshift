#!/bin/bash
cd /sdcard/Pictures/
# Start watching
while : ;do
	tree -ifl ./ | grep -E "\/[Ss]creenshot" | grep -E "\.[Jj][Pp][Gg]$" | while IFS= read -r file; do
		# Encode WebP
		if [ -e "$(which cwebp)" ]; then
			echo "Encoding '${file}' to WebP..."
			cwebp -m 5 -psnr 56 "${file}"
		fi
		# Encode JPEG XL
		if [ -e "$(which cjxl)" ]; then
			echo "Encoding '${file} to JPEG XL...'"
 			cjxl -d 1.1 -e 4 -p "${file}"
		fi
	done
done
exit
