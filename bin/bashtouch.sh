#!/usr/bin/env bash
# Author (c) 2020 Marcus Biesioroff biesior@gmail.com
# https://github.com/biesior/bash-scripts
# Latest updated in 1.0.1
# Donate author: https://www.paypal.com/paypalme/biesior/4.99EUR
#
# Description:
# Allows to fast create (touch) bash scripts and optionally open it in preferred editor
# for more details run `bashtouch -h`


AnsiRed="\033[31m"
AnsiGreen="\033[32m"
AnsiCyan="\033[36m"
AnsiReset="\033[0m"

if [ "$1" = "" ]; then
  echo -e "${AnsiRed}Error! ${AnsiReset}No filename specified"
  exit 1
fi

FileName="$1"
Shebang="#!/usr/bin/env bash"
if [[ "$FileName" == -h ]] || [[ "$FileName" == --help ]]; then
  echo -e "${AnsiGreen}bashtouch help: ${AnsiReset}
© 2020 Marcus biesior Biesioroff

Basic syntax:
${AnsiCyan}bashtouch <filepath><optional-extension> <optional editor>${AnsiReset}

Where:
${AnsiCyan}<filepath>${AnsiReset} is absolute or relative path for new created script
${AnsiCyan}<optional-extension>${AnsiReset} should be one of: ${AnsiGreen}.sh${AnsiReset}, ${AnsiGreen}.zsh${AnsiReset}, ${AnsiGreen}.bash${AnsiReset} for bash script, if none ${AnsiGreen}.sh${AnsiReset} will be added
${AnsiCyan}<optional editor> ${AnsiReset} If specified, after creation the file it will be opened in this editor, possibilities:

Command line editors (if installed):
${AnsiGreen}vim${AnsiReset}, ${AnsiGreen}nano${AnsiReset}, ${AnsiGreen}jed${AnsiReset}

GUI editors on Mac (if installed):
${AnsiGreen}edit${AnsiReset} for default OSX editor,
${AnsiGreen}sublime${AnsiReset} for OSX Sublime Text.app,
${AnsiGreen}textedit${AnsiReset} for OSX TextEdit.app

Samples:

${AnsiCyan}cd /path/with/your/executables${AnsiReset}

To create script with \`bash\` shebang
${AnsiCyan}bashtouch foo.sh${AnsiReset}

To create script with \`zsh\` shebang
${AnsiCyan}bashtouch bar.zsh${AnsiReset}

Auto extension if not given will be .sh:
${AnsiCyan}bashtouch baz${AnsiReset} (creates baz.sh)

Of course you can always use absolute or relative path for new file like:
${AnsiCyan}bashtouch /full/path/to/zen.sh${AnsiReset}
${AnsiCyan}bashtouch ~/in-home-directory.sh${AnsiReset}
${AnsiCyan}bashtouch in-current-directory.sh${AnsiReset}

If for some reason you want/need to use file without extension, just rename it like:
${AnsiCyan}mv new-script.sh new-script${AnsiReset}
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
printf "${Shebang}

# Below code can be removed or replaced
echo \"Hello World!\"

if [ -n \"\$BASH_VERSION\" >/dev/null ]; then
  echo  \"Using bash shell ver.: \$BASH_VERSION\"
elif [ -n \"\$ZSH_VERSION\" >/dev/null ]; then
   echo  \"Using zsh shell ver.: \$ZSH_VERSION\"
else
   echo \"Using another shell\"
fi

exit 0" >>"$FileName"
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

exit