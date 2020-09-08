#!/usr/bin/env bash
# Author (c) 2020 Marcus Biesioroff biesior@gmail.com
#
# Donate author: https://paypal.me/biesior/4.99EUR
#
# Description:
# Allows to fast create (touch) bash scripts and optionally open it in preferred editor
# for more details run `bashtouch.sh -h`

# Try to not change anything below
# If you think you can improve this script, share with us via:
# https://github.com/biesior/bash-scripts/issues

# Semantic version for this script:
SemanticProject='bashtouch.sh'
SemanticVersion='1.0.3'
SemanticRepository='https://github.com/biesior/bash-scripts/'

DocumentStyle=default
#. ~/.bash_profile

if [ "$BASHTOUCH_COLORS" = false ]; then
  DocumentStyle=raw

fi





# ╔════════════════════════╗
# ║ Format functions START ║
# ╚═════╦══════════════════╝
#═══════╩══════════════════════════════════════════════════════════════════════

function programSuccess() {
  case $DocumentStyle in
  raw) echo -e "OK!\n$1\n\n" ;;
  markdown) ;;
  default | *) echo -e "\033[1;32mOK!\033[0m\n$1\n\n" ;;
  esac
}

function catFile() {
  case $DocumentStyle in
  raw) echo -e "File's content:\n$1\n\n" ;;
  markdown) ;;
  default | *)
    echo -e "\033[1;32mFile's content:\033[0m"
    echo -e "\033[0;36m"
    cat "$1"
    echo -e "\033[0m"

    ;;
  esac
}


function programError() {
  case $DocumentStyle in
  raw) echo -e "Error!\n$1\n\n" ;;
  markdown) ;;
  default | *) echo -e "\033[1;31mError!\033[0m\n$1\n\n" ;;
  esac
}

function text() { echo -e "$1"; }

function header() {
  case $DocumentStyle in
  raw) echo -e "* $2" ;;
  markdown)
    for i in $(seq 1 "$1"); do echo -n "#"; done
    echo -ne " $2  "
    ;;
  default | *) echo -e "\033[32m$2\033[0m\n" ;;
  esac
}

function headerInline() {
  case $DocumentStyle in
  raw) echo -e "$1" ;;
  markdown) echo -e "$1" ;;
  default | *) echo -e "\033[0;33m$1\033[0m" ;;
  esac
}

#[![Donate](https://img.shields.io/static/v1?label=Donate&message=paypal.me/biesior&color=brightgreen "Donate the contributor via PayPal.me, amount is up to you")](https://www.paypal.me/biesior/4.99EUR)
#[![State](https://img.shields.io/static/v1?label=alpha&message=0.0.16&color=blue 'Latest known version')](https://github.com/biesior/semantic-version/tree/0.0.16-alpha) <!-- __SEMANTIC_VERSION_LINE__ -->
#![Updated](https://img.shields.io/static/v1?label=upated&message=2020-08-30+04:29:47&color=lightgray 'Latest known update date')

function badges() {
  case $DocumentStyle in
  #  raw) ;;
  markdown)
    printf "[![%s](https://img.shields.io/static/v1?label=Donate&message=paypal.me/biesior&color=brightgreen 'Donate the contributor via PayPal.me, amount is up to you')](https://www.paypal.me/biesior/4.99EUR)
[![State](https://img.shields.io/static/v1?label=stable&message=${SemanticVersion}&color=blue 'Latest known version')](https://github.com/biesior/bash-scripts/)
[![Minimum bash version](https://img.shields.io/static/v1?label=bash&message=3.2+or+higher&color=blue 'Minimum Bash version to run this script')](https://www.gnu.org/software/bash/)
" "Donate"
    ;;
  default | *) ;;
  esac
}

function inlineCode() {
  case $DocumentStyle in
  raw) echo -ne "$1" ;;
  markdown) echo -ne "\`$1\`" ;;
  default | *) echo -ne "\033[36m$1\033[0m" ;;
  esac
}
function mdEndLine() {
  case $DocumentStyle in
  raw) ;;
  markdown) echo -ne "  " ;;
  default | *) ;;
  esac
}

function inlineValue() {
  if [ "$2" = no-ticks ]; then
    Tick=''
  else
    Tick="\`"
  fi
  case $DocumentStyle in
  raw) echo -ne "$1" ;;
  markdown) echo -ne "${Tick}${1}${Tick}" ;;
  default | *) echo -ne "\033[32m$1\033[0m" ;;
  esac
}

function codeBlock() {
  case $DocumentStyle in
  raw) echo -e "$2" ;;
  markdown) echo -e "\`\`\`$1\n$2\n\`\`\`" ;;
  *) echo -ne "\033[36m$2\033[0m" ;;
  esac
}

function startDocument() { echo -e "\n"; }
function finishDocument() { echo -e "\n"; }

#═══════╦══════════════════════════════════════════════════════════════════════
# ╔═════╩════════════════╗
# ║ Format functions END ║
# ╚══════════════════════╝

if [ "$1" = "" ]; then
  programError "No filename specified!
Use $(inlineCode "bashtouch.sh -h") for help"
  exit 1
fi

# ╔════════════════════════╗
# ║ Render help            ║
# ╚═════╦══════════════════╝
#═══════╩══════════════════════════════════════════════════════════════════════

function renderHelp() {

  if [ "$2" = "markdown" ] || [ "$2" = "raw" ]; then
    DocumentStyle="$2"
  fi

  startDocument

  text "$(header 1 "Help for $(inlineValue $SemanticProject) ver. $(inlineValue $SemanticVersion)")
$(badges)

$(header 3 "What it does?")

As name suggest $(inlineCode "touch") version of command for bash scripts.
It just creates scratch shell script with $(inlineValue ".sh") or $(inlineValue ".zsh"), proper shebang and sample code inside.

You can reuse sample code or remove it and write your own.

Just leave generated shebang.
See: https://en.wikipedia.org/wiki/Shebang_(Unix)

$(header 3 "Where")

$(inlineCode "<filepath>") is absolute or relative path for new created script, if filename only given it will create script in current directory

$(inlineCode "<extension>") should be $(inlineValue ".sh") or $(inlineValue ".zsh"), if not specified $(inlineValue ".sh") will be added automatically.

$(inlineCode "<output>") If specified, after creation the file it will be opened in this editor, possibilities:

  $(header 5 "Display")

  - $(inlineValue "cat") displays generated code in terminal
  - $(inlineValue "none") or blank finishes

  $(header 5 "Command line editors (if installed)")

  - $(inlineValue "vim")
  - $(inlineValue "nano")
  - $(inlineValue "jed")

  $(header 5 "GUI editors on Mac (if installed)")

  - $(inlineValue "edit") for default OSX editor
  - $(inlineValue "sublime") for OSX Sublime Text.app
  - $(inlineValue "textedit") for OSX TextEdit.app

$(header 3 "Samples")

$(header 5 "(optionally)")

$(codeBlock bash "cd /path/with/your/executables")

$(header 5 "To create script with $(inlineValue "#!/usr/bin/env bash") $(headerInline 5 "shebang")")

$(codeBlock bash "bashtouch.sh foo.sh")

$(header 5 "To create script with $(inlineCode "#!/usr/bin/env zsh") $(headerInline 5 "shebang")")
$(codeBlock bash "bashtouch.sh foo.zsh")

$(header 5 "If extension is not given. default bash is created:")

$(inlineCode "bashtouch.sh baz")  (creates $(inlineValue "baz.sh") with $(inlineValue "#!/usr/bin/env bash") shebang)

$(header 5 "Of course you can always use absolute or relative path for new file like:")

$(codeBlock bash "bashtouch.sh /full/path/to/zen.sh
bashtouch.sh ~/in-home-directory.sh
bashtouch.sh in-current-directory.sh")

$(header 5 "If for some reason you want/need to use file without extension, just rename it after creation like")

$(codeBlock bash "mv new-script.sh new-script")

$(header 3 "Exported variables")

To modify final output you can export some variables in your shell before executing $(inlineCode "bashtouch.sh")
or add selected exports to your profile file.

$(header 5 "To check current exported variables, just $(inlineCode echo) $(inlineValue 'one of them in your terminal, like') ")
$(codeBlock bash "echo \$BASHTOUCH_DEFAULT")

$(header 5 "To disable sample body (allowed $(inlineCode 'true'), $(inlineCode 'false')):")
$(codeBlock bash "export BASHTOUCH_BODY=false")

$(header 5 "To disable generator comment (allowed $(inlineCode 'true'), $(inlineCode 'false')):")
$(codeBlock bash "export BASHTOUCH_COMMENT=false")

$(header 5 "To disable colored output (allowed $(inlineCode 'true'), $(inlineCode 'false')):")
$(codeBlock bash "export BASHTOUCH_COLORS=false")

$(header 5 "To set default extension to be used when auto mode")
* required extension must be no-spaces word, starting with dot like $(inlineValue '.sh'), $(inlineValue '.zsh'), $(inlineValue '.my-own-extension')$(mdEndLine)
* suggested $(inlineValue '.sh') or $(inlineValue '.zsh')$(mdEndLine)
* default $(inlineValue '.sh')$(mdEndLine)
$(codeBlock bash "export BASHTOUCH_DEFAULT=$(inlineValue '.sh' no-ticks)")


$(header 5 "That's all!")
Now you can run:
$(codeBlock bash "bashtouch.sh have-fun-:-p")

© 2020 Marcus biesior Biesioroff"

  finishDocument

}

if [[ $BASHTOUCH_DEFAULT == "" ]]; then
  echo -e "Please do not use empty extension with this script, \ninstead create file with real extension and rename it with $(inlineCode mv) command if really needed"
fi
if [[ $BASHTOUCH_DEFAULT == *.* ]]; then
  DefaultExtension=$BASHTOUCH_DEFAULT
fi
echo global: "$BASHTOUCH_DEFAULT"
echo local: "$DefaultExtension"

# ╔════════════════════════╗
# ║ Render output          ║
# ╚═════╦══════════════════╝
#═══════╩══════════════════════════════════════════════════════════════════════

function renderOutput() {

  if [[ "$FileName" == -* ]]; then
    programError "Filename cannot start with $(inlineValue "-") (except of $(inlineValue "-h") for help)"
    exit 1
  fi

  if test -f "$FileName"; then
    programError "File $(inlineValue "$FileName") already exists!"
    exit 1
  fi

  touch "$FileName"

  if [[ $BASHTOUCH_COMMENT != 'false' ]]; then
    ScriptComment="# This $ScriptType script was touched by $SemanticProject $SemanticVersion
# $SemanticRepository
"
  fi
  if [[ $BASHTOUCH_BODY != 'false' ]]; then
    ScriptBody="# Of course you can remove or replace this sample code
# Check documentation for permanent disabling it with exported variables
echo \"Hello World!\"

if [ -n \"\$BASH_VERSION\" ] >/dev/null; then
  echo \"Using bash shell ver.: \$BASH_VERSION\"
elif [ -n \"\$ZSH_VERSION\" ] >/dev/null; then
  echo \"Using zsh shell ver.: \$ZSH_VERSION\"
else
  echo \"Using another shell\"
fi

exit 0

# eof
"
  fi

  printf "%s

$ScriptComment
$ScriptBody

" "$Shebang" >>"$FileName"

  #echo "# eof"

  chmod +x "$FileName"

  programSuccess "Script $(inlineValue "$FileName") created and chmoded $(inlineValue "+x") "

  if [ "$2" ]; then
    case "$2" in
    "" | cat)
      #    programSuccess "New content: "
      catFile "$FileName"
      #    echo -ne "\033[36m"
      #    cat "$FileName"
      #    echo -ne "\033[0m"
      ;;
    vim) vim "$FileName" ;;
    nano) nano "$FileName" ;;
    jed) jed "$FileName" ;;
    edit) open -t "$FileName" ;;
    sublime) open -a "Sublime Text" "$FileName" ;;
    textedit) open -e "$FileName" ;;
    silent) ;;
    *)
      echo -e "Invalid option for editor, next time try,

- Commandline editors:
  $(inlineValue "vim")
  $(inlineValue "nano")
  $(inlineValue "jed")

- OSX GUI editors
  $(inlineValue "edit") for system default editor
  $(inlineValue "sublime") for 'Sublime Text.app'
  $(inlineValue "textedit") for 'TextEdit.app'

    "
      ;;
    esac

  fi

  exit 0
}
FileName="$1"
if [[ "$FileName" == -h ]] || [[ "$FileName" == --help ]]; then
  renderHelp "$1" "$2"
  exit 0
elif [[ "$FileName" == *.sh ]]; then
  Shebang="#!/usr/bin/env bash"
  ScriptType="bash"
  FileName="$1"
elif [[ "$FileName" == *.zsh ]]; then
  ScriptType="zsh"
  Shebang="#!/usr/bin/env zsh"
  FileName="$1"
else
  if test -d "$FileName"; then
    programError "$(inlineValue "$FileName") is a directory!!"
    exit 1
  fi
  ScriptType="bash"
  FileName="${1}${DefaultExtension}"
fi

if [[ "$FileName" == -h ]] || [[ "$FileName" == --help ]]; then
  renderHelp "$1" "$2"
  exit 0
else
  echo "konie1111"
  exit 1
  renderOutput "$1" "$2"
fi
