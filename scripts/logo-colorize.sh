#!/usr/bin/env bash
# colorize textual logo
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
# usage: scripts/logo-colorize.sh <TEXT_LOGO_SOURCE>
#
# This script loads logo file and for each char, it inserts:
#
#   - C1, if the char is a space;
#   - otherwise, C2
#
# before the char, and then append C0.
#
# The C0, C1, and C2 are the environment variables.  The output is printed out
# to standard output, and the loaded logo is to standard error for
# confirmation.
#
# The format of a textual logo file is:
#
#   - 20 chars by 10 lines, anything beyond will be cut off
#   - '1' and '2' indicate the position is a space colorized with C1 or C2,
#     respectively.


LOGO_W=20
LOGO_H=10


load_logo()
{
    mapfile -n $LOGO_H -t LOGO <"$1"

    local i
    for ((i = 0; i < $LOGO_H; i++)); do
        local line=${LOGO[i]:0:LOGO_W}
        LOGO[i]="$line$(printf '%*s' $((LOGO_W - ${#line})) '')"
    done
}


print_LOGO()
{
    local i
    for ((i = 0; i < $LOGO_H; i++)); do
        echo "${LOGO[i]}"
    done
}


# replace special characters 'F' and 'B' with spaces
_char()
{
    local c=$1
    [[ $1 == [' '12] ]] && c=' '
    printf "$c"
}


_colorize()
{
    if [[ $1 == [' '1] ]]; then
        printf "$C1$(_char "$1")$C0"
    else
        printf "$C2$(_char "$1")$C0"
    fi
}


colorize()
{
    local i
    for ((i = 0; i < $LOGO_H; i++)); do
        local x line="${LOGO[i]}"
        for ((x = 0; x < $LOGO_W; x++)); do
            _colorize "${line:x:1}"
        done
        echo
    done
    
}


main()
{
    load_logo "$1"
    print_LOGO >&2
    colorize
}


main "$@"
