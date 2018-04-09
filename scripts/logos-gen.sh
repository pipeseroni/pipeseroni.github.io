#!/usr/bin/env bash
# generate a set of logos
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or distribute
# this software, either in source code form or as a compiled binary, for any
# purpose, commercial or non-commercial, and by any means.
#
# In jurisdictions that recognize copyright laws, the author or authors of this
# software dedicate any and all copyright interest in the software to the
# public domain. We make this dedication for the benefit of the public at large
# and to the detriment of our heirs and successors. We intend this dedication
# to be an overt act of relinquishment in perpetuity of all present and future
# rights to this software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org>
#
# usage: scripts/logos-gen.sh <TEXT_LOGO_SOURCE> [BASENAME]
#
# This script generates a set of logos (${LOGO[@]} as settings) to where the
# textual logo file is, using scripts/colorize-logo.sh, with BASENAME-suffix as
# the output filename of each generated logo, BASENAME defaults to source
# filename without .txt extension.


RST=$'\e[0m'

BG_24BIT=$'\e[48;2;60;56;103m'
FG_24BIT=$'\e[48;2;243;54;54m\e[38;2;243;54;54m'

#          $((16 + 36 * R + 6 * G + B))
BG_256_IDX=$((16 + 36 * 1 + 6 * 1 + 2))
FG_256_IDX=$((16 + 36 * 5 + 6 * 1 + 1))
BG_256=$"\e[48;5;${BG_256_IDX}m"
FG_256=$"\e[48;5;${FG_256_IDX}m\e[38;5;${FG_256_IDX}m"

BG_16=$'\e[44m'
FG_16=$'\e[41;31m'


LOGOS=(
    # suffix        C1              C2              C0
    '-plain.txt'    ''              ''              ''
    '-24bit.txt'    "$BG_24BIT"     "$FG_24BIT"     "$RST"
    '-256.txt'      "$BG_256"       "$FG_256"       "$RST"
    '-16.txt'       "$BG_16"        "$FG_16"        "$RST"
)
LOGOS_FIELDS=4


main()
{
    local LOGO=$1
    local LOGO_BASE=${2:-$(basename -s .txt "$LOGO")}
    local OUTDIR=$(dirname "$LOGO")
    local COLORIZER=$(dirname "${BASH_SOURCE[0]}")/logo-colorize.sh

    local i
    for ((i = 0; i < ${#LOGOS[@]}; i += LOGOS_FIELDS)); do
        local output=$OUTDIR/$LOGO_BASE${LOGOS[i]}
        echo "$output"
        C1=${LOGOS[i + 1]} \
        C2=${LOGOS[i + 2]} \
        C0=${LOGOS[i + 3]} \
        "$COLORIZER" "$LOGO" 2>/dev/null | tee "$output"
    done
}


main "$@"
