#!/bin/bash
# translit.sh — rename files and folders from Cyrillic (Ukrainian and Russian)
# to Latin, recursively. Spaces become underscores.
#
# Usage: translit.sh [dir]     (default: the current directory)
#
# It renames for real, with no confirmation and no undo, so try it on a copy
# first. An existing file is never overwritten: that rename is skipped.
#
# Example: "Привіт світ.txt" -> "Privit_svit.txt"
#
# Improved by Dumitru Uzun (https://DUzun.Me)
# Источник: http://www.ubuntu.sumy.ua/2011/03/translit.html

shopt -s nullglob
# sed and iconv need a UTF-8 locale to see Cyrillic letters at all
export LC_ALL=en_US.UTF-8

# translit "стринг"
# echo "текст" | translit
# translit <<< "стдин"
translit() {
    local NAME=${*:-$(cat)};
    local TRS;
    TRS=$(sed "y/абвгдезийклмнопрстуфхцыіґ/abvgdezijklmnoprstufxcyig/" <<< "$NAME")
    TRS=$(sed "y/АБВГДЕЗИЙКЛМНОПРСТУФХЦЫІҐ/ABVGDEZIJKLMNOPRSTUFXCYIG/" <<< "$TRS")
    TRS=${TRS//ч/ch};
    TRS=${TRS//Ч/CH} TRS=${TRS//ш/sh};
    TRS=${TRS//Ш/SH} TRS=${TRS//ё/jo};
    TRS=${TRS//Ё/JO} TRS=${TRS//ж/zh};
    TRS=${TRS//Ж/ZH} TRS=${TRS//щ/sh\'};
    TRS=${TRS//Щ/SH\'} TRS=${TRS//э/je};
    TRS=${TRS//Э/JE} TRS=${TRS//ю/ju};
    TRS=${TRS//Ю/JU} TRS=${TRS//я/ja};
    TRS=${TRS//Я/JA} TRS=${TRS//ъ/\`};
    TRS=${TRS//Ъ/\`} TRS=${TRS//ь/\'};
    TRS=${TRS//Ь/\'} TRS=${TRS//є/je};
    TRS=${TRS//Є/JE} TRS=${TRS//ї/ji};
    TRS=${TRS//Ї/JI}
    hash iconv &> /dev/null && TRS=$(iconv -c -f UTF8 -t ASCII//TRANSLIT <<< "$TRS")
    echo "$TRS";
}

trans_mv() {
    local dir=${1:-$PWD}
    local NAME BASE TRS
    for NAME in "$dir"/* ; do
        # only the last part of the path changes; the parent is already renamed
        BASE=${NAME##*/}
        TRS="$dir/$(translit <<< "${BASE// /_}")"
        if [ "$NAME" != "$TRS" ]; then
            mv -nv "$NAME" "$TRS"
        fi
        if [ -d "$TRS" ]; then
            trans_mv "$TRS"
        fi
    done
}

trans_mv "$1"
