#!/usr/bin/env bash
# Author (c) 2020 Marcus Biesioroff biesior@gmail.com
# https://github.com/biesior/bash-scripts
# Latest updated in 1.0.2
# Donate author: https://paypal.me/biesior/4.99EUR
#
# Description:
# Allows to fast create (touch) bash scripts and optionally open it in preferred editor
# for more details run `bashtouch.sh -h`

# To disable colors permanently, just set DisableColors to true.
DisableColors=false

# Try to not change anything below
# If you think you can improve this script, share with us via:
# https://github.com/biesior/bash-scripts/issues

AnsiRed="\033[31m"
AnsiGreen="\033[32m"
AnsiCyan="\033[36m"
AnsiReset="\033[0m"
function disableColors() {
  AnsiRed=""
  AnsiGreen=""
  AnsiCyan=""
  AnsiReset=""
}
if [ $DisableColors = true ]; then
  disableColors
fi

if [ "$1" = "" ]; then
  echo -e "${AnsiRed}Error! ${AnsiReset}No filename specified
Use ${AnsiCyan}bashtouch.sh -h${AnsiReset} for help
"
  exit 1
fi

FileName="$1"
Shebang="#!/usr/bin/env bash"
if [[ "$FileName" == -h ]] || [[ "$FileName" == --help ]]; then
  echo -e "
${AnsiGreen}Help for bashtouch.sh ver.: 1.0.2 ${AnsiReset}

© 2020 Marcus biesior Biesioroff

${AnsiGreen}What it does?${AnsiReset}
As name suggest it's bash's \`touch\` version for bash scripts.
It just creates scratch shell script with ${AnsiGreen}.sh${AnsiReset} or ${AnsiGreen}.zsh${AnsiReset}, proper shebang and sample code inside.

You can reuse sample code or remove it and write your own.

Just leave generated shebang.
See: https://en.wikipedia.org/wiki/Shebang_(Unix)

${AnsiGreen}Basic syntax:${AnsiReset}

  ${AnsiCyan}bashtouch.sh <filepath><optional-extension> <optional editor>${AnsiReset}

${AnsiGreen}Where:${AnsiReset}

  ${AnsiCyan}<filepath>${AnsiReset} is absolute or relative path for new created script, if filename only given it will create script
             in current directory
  ${AnsiCyan}<optional-extension>${AnsiReset} should be one of: ${AnsiGreen}.sh${AnsiReset}, ${AnsiGreen}.zsh${AnsiReset}, ${AnsiGreen}.bash${AnsiReset} for bash script, if none ${AnsiGreen}.sh${AnsiReset} will be added
  ${AnsiCyan}<optional editor> ${AnsiReset} If specified, after creation the file it will be opened in this editor, possibilities:

- Command line editors (if installed):
  ${AnsiGreen}vim${AnsiReset}, ${AnsiGreen}nano${AnsiReset}, ${AnsiGreen}jed${AnsiReset}

- GUI editors on Mac (if installed):
  ${AnsiGreen}edit${AnsiReset} for default OSX editor,
  ${AnsiGreen}sublime${AnsiReset} for OSX Sublime Text.app,
  ${AnsiGreen}textedit${AnsiReset} for OSX TextEdit.app

${AnsiGreen}Samples:${AnsiReset}

- (optionally)
  ${AnsiCyan}cd /path/with/your/executables${AnsiReset}

- To create script with \`bash\` shebang
  ${AnsiCyan}bashtouch.sh foo.sh${AnsiReset}

- To create script with \`zsh\` shebang
  ${AnsiCyan}bashtouch.sh bar.zsh${AnsiReset}

- Auto extension if not given will be .sh:
  ${AnsiCyan}bashtouch.sh baz${AnsiReset} (creates baz.sh)

- Of course you can always use absolute or relative path for new file like:
  ${AnsiCyan}bashtouch.sh /full/path/to/zen.sh${AnsiReset}
  ${AnsiCyan}bashtouch.sh ~/in-home-directory.sh${AnsiReset}
  ${AnsiCyan}bashtouch.sh in-current-directory.sh${AnsiReset}

If for some reason you want/need to use file without extension, just rename it after creation like:
${AnsiCyan}mv new-script.sh new-script${AnsiReset}

${AnsiGreen}To disable colors permanently:${AnsiReset}
Just edit the file and set value of ${AnsiCyan}DisableColors${AnsiReset} variable to ${AnsiGreen}true${AnsiReset}.

${AnsiGreen}Have fun :)${AnsiReset}
"
  exit
fi

if [[ "$FileName" == -* ]]; then
  echo -e "${AnsiRed}Error! ${AnsiReset}Filename cannot start with -"
  exit 1
fi

if [[ "$FileName" == *.sh ]] || [[ "$FileName" == *.bash ]]; then
  FileName="$1"
elif [[ "$FileName" == *.zsh ]]; then
  Shebang="#!/usr/bin/env zsh"
else
  FileName="$1".sh
fi

if test -d "$FileName"; then
  echo -e "${AnsiRed}Error! ${AnsiReset} ${AnsiCyan}${FileName}${AnsiReset} is a directory!"
  exit 1
fi

if test -f "$FileName"; then
  echo -e "${AnsiRed}Error! ${AnsiReset}File ${AnsiCyan}${1}${AnsiReset} already exists!"
  exit 1
fi

touch "$FileName"
printf "%s

# Below code can be removed or replaced
echo \"Hello World!\"

if [ -n \"\$BASH_VERSION\" >/dev/null ]; then
  echo  \"Using bash shell ver.: \$BASH_VERSION\"
elif [ -n \"\$ZSH_VERSION\" >/dev/null ]; then
   echo  \"Using zsh shell ver.: \$ZSH_VERSION\"
else
   echo \"Using another shell\"
fi

exit 0" "$Shebang" >>"$FileName"
chmod +x "$FileName"
echo -e "${AnsiGreen}OK! ${AnsiReset}Script ${AnsiCyan}${FileName}${AnsiReset} created and chmoded +x"

if [ "$2" ]; then
  case "$2" in
  vim) vim "$FileName" ;;
  nano) nano "$FileName" ;;
  jed) jed "$FileName" ;;
  edit) open -t "$FileName" ;; # OSX specific, default text editor
  sublime) open -a "Sublime Text" "$FileName" ;; # OSX specific, system app TextEdit.app
  textedit) open -e "$FileName" ;; # OSX specific, system app TextEdit.app
  *) echo -e "Invalid option for editor, next time try one of: ${AnsiCyan}vim${AnsiReset}, ${AnsiCyan}nano${AnsiReset}, ${AnsiCyan}jed${AnsiReset}, ${AnsiCyan}edit${AnsiReset}, ${AnsiCyan}textedit${AnsiReset}" ;;
  esac
fi

exit 0
