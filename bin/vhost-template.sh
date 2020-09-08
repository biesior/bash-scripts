#!/bin/bash
# Author (c) 2020 Marcus Biesioroff biesior@gmail.com
# https://github.com/biesior/bash-scripts
# Donate author: https://paypal.me/biesior/4.99EUR
#
# Description
# This script doesn't create or modify any existing files it's for learning purposes,
# however _may_ be used for creating own vhosts
# just download and modify some first variables below, to fir your lsb_release -a
# This sample was created at Mac, so it should be adaptable at any linux
#
# Check the help with -h option for more informations

# Semantic version for this script:
SemanticProject='vhost-template.sh'
SemanticVersion='1.0.3'

# most probably you will need to change these
CFG_EDITOR="open -e"
CFG_APACHE_PATH="/xampp/etc/"
CFG_VHOST_FILE="/xampp/etc/extra/httpd-vhosts.conf"
CERT_FOLDER="/xampp/etc/ssl/"

# don't change these without reason, you can set them via options, see help
IS_MARKDOWN=false
INTERACTIVE=false
TOPIC=basic
MUTED=false

###################################
######
###### DONT CHANGE ANYTHING BELLOW!
######
###################################

# Just for coloring like a kid :D
function setDefaultStyle() {
  FirstLine="
"

  LastLine="

"
  AnsiBlack="\033[0;30m"
  AnsiRed="\033[0;31m"
  AnsiGreen="\033[0;32m"
  AnsiYellow="\033[0;33m"
  AnsiBlue="\033[0;34m"
  AnsiMagenta="\033[0;35m"
  AnsiCyan="\033[0;36m"
  AnsiWhite="\033[0;37m"
  AnsiDim="\033[2;37m"
  AnsiEscape="\033[0m"
  CodeBlock="\033[0;36m"
  CodeColor="\033[0;36m"
  HelpColor="\033[0;36m"
  CodeInline="\033[0;36m"
  CodeBlockEsc="\033[0m"
  CodeInlineEsc="\033[0m"
}

function setRawStyle() {
  FirstLine=""
  LastLine=""
  CodeBlock=""
  CodeColor=""
  CodeBlockEsc=""

  CodeInline=""
  CodeInlineEsc=""

  HelpColor=""

  AnsiBlack=""
  AnsiRed=""
  AnsiGreen=""
  AnsiYellow=""
  AnsiBlue=""
  AnsiMagenta=""
  AnsiCyan=""
  AnsiWhite=""
  AnsiDim=""
  AnsiEscape=""

  Header1=""
  Header2=""
  Header3=""
  Header4=""
  Header5=""
  Header6=""



  #  echo Using raw mode now
}
function setMarkdownStyle() {
  setRawStyle

  Header1="# "
  Header2="## "
  Header3="### "
  Header4="#### "
  Header5="##### "
  Header6="###### "


  CodeBlock="\`\`\`
"
  CodeBlockEsc="
\`\`\`"

  CodeInline="\`"
  CodeInlineEsc="\`"
  #  echo Using markdown mode now
}

DOMAIN=$1
ROOT=$2

function renderBasic_0() {
  if [ "$MUTED" != true ]; then
    echo -e "
${AnsiGreen}Aloha!${AnsiEscape}

This is some suggestion for your ${AnsiGreen}${DOMAIN}${AnsiEscape} domain with root in ${AnsiGreen}${ROOT}${AnsiEscape} directory

${AnsiYellow}Note it doesn't modify your existing files, just show some sample${AnsiEscape}

Just place it in your ${CodeInline}httpd-vhosts.conf${CodeInlineEsc} file.
And don't forget to restart the Apache server!
"
  fi #muted

  echo -e "${CodeBlock}${AnsiDim}# Virtual host for ${DOMAIN}${AnsiEscape}
${CodeColor}<VirtualHost *:80>

    ServerAdmin youremail+${DOMAIN}@gmail.com
    DocumentRoot \"${ROOT}\"
    ServerName ${DOMAIN}
    ServerAlias *.${DOMAIN}
    ErrorLog  \"logs/${DOMAIN}-error_log\"
    CustomLog \"logs/${DOMAIN}-access_log\" common

    <Directory \"${ROOT}\">
        Options Indexes FollowSymLinks ExecCGI Includes
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>

</VirtualHost>${CodeBlockEsc}
"

} #end of renderBasic()

function renderSSL_1() {
  if [ $MUTED != true ]; then
    echo -e "Optionally you can add SSL:"
  fi
  echo -e "
${AnsiDim}# Virtual SSL host for ${DOMAIN} (if certificate created)${AnsiEscape}
${CodeBlock}<VirtualHost ${DOMAIN}:443>

    ServerAdmin youremail+${DOMAIN}@gmail.com
    DocumentRoot \"${ROOT}\"
    ServerName ${DOMAIN}
    ServerAlias *.${DOMAIN}
    ErrorLog  \"logs/${DOMAIN}-error_log\"
    CustomLog \"logs/${DOMAIN}-access_log\" common

   SSLEngine on
   SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
   SSLCertificateFile ${CERT_FOLDER}${DOMAIN}.crt
   SSLCertificateKeyFile ${CERT_FOLDER}${DOMAIN}.key

   <Directory \"${ROOT}\">
       Options Indexes FollowSymLinks ExecCGI Includes
       AllowOverride All
       Order allow,deny
       Allow from all
       Require all granted
   </Directory>
</VirtualHost>${CodeBlockEsc}

"
} # end of renderSSl

function renderCerts_2() {
  if [ $MUTED != true ]; then
    echo -e "
${AnsiGreen}Welcome :D This script shows how to enable SSL vhost fpr different ways${AnsiEscape}

This script is bring to you by ${AnsiRed}Marcus Biesioroff ];->${AnsiEscape}

Concept by: ${AnsiGreen}Xcreate${AnsiEscape}, you can see his talking head here: ${AnsiGreen}https://www.youtube.com/watch?v=-VxQU1w9L6w${AnsiEscape}, kudos!

Things to do${AnsiEscape}

To create keys first create a dir ${AnsiYellow}(if doesn't exist only)${AnsiEscape}

${CodeBlock}sudo mkdir ${CFG_APACHE_PATH}ssl${CodeBlockEsc}

Generate certificates"
  fi

  echo -e "
${CodeInline}sudo openssl genrsa -out ${CFG_APACHE_PATH}ssl/${DOMAIN}.key 2048${CodeInlineEsc}
${CodeInline}sudo openssl req -new -x509 -key ${CFG_APACHE_PATH}ssl/$DOMAIN.key -out ${CFG_APACHE_PATH}ssl/${DOMAIN}.crt -days 3650 -subj /CN=${DOMAIN}${CodeInlineEsc}"

  if [ $MUTED != true ]; then
    echo -e "
Add new certificate to Keychains"
  fi
  echo -e "
${CodeBlock}sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ${CFG_APACHE_PATH}ssl/${DOMAIN}.crt${CodeBlockEsc}"

  if [ $MUTED != true ]; then
    echo -e "
Setup VHOST  with port ${AnsiGreen}443${AnsiEscape}

Open your vhosts file"
  fi

  echo -e "
${CodeBlock}${CFG_EDITOR} ${CFG_VHOST_FILE}${CodeBlockEsc}"

  if [ $MUTED != true ]; then
    echo -e "
And add this vhost ${AnsiYellow}(modify if exists)${AnsiEscape}

"
  fi
}
function renderDefaultCert_3() {
  if [ $MUTED != true ]; then
    echo -e "
If you want to set default certificate for all domains edit this file
${AnsiRed}(be careful! it's enough to setup separate cert for each local domain)${AnsiEscape}"
  fi #muted

  echo -e "
${CodeBlock}${CFG_EDITOR} ${CFG_APACHE_PATH}extra/httpd-ssl.conf${CodeBlockEsc}"

  if [ $MUTED != true ]; then
    echo -e "And change these values:"
  fi

  echo -e "
${CodeBlock}SSLCertificateFile \"${CFG_APACHE_PATH}/ssl /${DOMAIN}.crt\"
SSLCertificateKeyFile \"${CFG_APACHE_PATH}/ssl /${DOMAIN}.key\"${CodeBlockEsc}

"
  if [ $MUTED != true ]; then
    echo -e "
${AnsiGreen}That's all about certificates, bye :)${AnsiEscape}

"
  fi #muted
} #end of renderDefaultCert()

function die() {
  pressAnyKeyToFinish
  printf '%s\n' "$1" >&2
  exit 1
}

function displayHint() {
  echo $'\033[0;31mHey! Wrong arguments supplied, exactly three: domain, rootpath and third y or n for markdown are required like:\033[0m


\033[0;32mvhost-template.sh  domain.loc /www/projects/domain y\033[0m'
} # displayHint() end

function clearConsole() {
  printf "\033c"
}

function pressAnyKeyToContinue() {
  if [ "$INTERACTIVE" = true ]; then
    read -n 1 -s -r -p $'

\033[2;37m(press any key to finish...)\033[0m
'
  fi
}
function pressAnyKeyToFinish() {
  if [ "$INTERACTIVE" = true ]; then
    read -n 1 -s -r -p $'

\033[2;37m(press any key to finish...)\033[0m
'
  fi
}
function pressEnterToContinue() {
  if [ "$INTERACTIVE" = true ]; then
    read -r -p $'

\033[2;37m(press enter to continue...)\033[0m
'
    clearConsole
  fi

}
# pressAnyKey() end

function pause() {
  read -rp "$*"
}

function firstCheck() {
  if [ $# -ne 3 ]; then
    displayHint
    pressAnyKeyToFinish
    exit 1
  fi

  echo Markdown is "$IS_MARKDOWN"
} # firstCheck() end
function suggestOtherTopics() {
  if [ $MUTED != true ]; then
    echo -e "${AnsiGreen}Info:${AnsiEscape}

You can also try these topics: ${AnsiGreen}-t basic${AnsiEscape}, ${AnsiGreen}-t ssl${AnsiEscape}, ${AnsiGreen}-t cert${AnsiEscape}, ${AnsiGreen}-t all${AnsiEscape}"
  fi
}
function sayGoodBye() {
  if [ $MUTED != true ]; then
    echo -e "

${AnsiGreen}Bye :)${AnsiEscape}
"
  fi
} # sayGoodbye() end

function showHelp() {
  echo -e "${FirstLine}${Header1}${AnsiGreen}Help for ${CodeInline}${SemanticProject}${CodeInlineEsc} ver.: ${CodeInline}${SemanticVersion}${CodeInlineEsc}${AnsiEscape}

© 2020 Marcus biesior Biesioroff

${CodeBlock}${HelpColor}-h --help${AnsiEscape}         To display this help
${HelpColor}-d --domain${AnsiEscape}       (required) name of the domain for this VHOST <ServerName>
${HelpColor}-r --root${AnsiEscape}         (required) name of the domain for this VHOST <DocumentRoot>
${HelpColor}-t --topic${AnsiEscape}        Topic to display, possible values

                  ${HelpColor}basic${AnsiEscape} Displays basic VHOST at port 80
                  ${HelpColor}ssl${AnsiEscape}   Displays SSL VHOST at port 443 and explains how to create certificate files
                  ${HelpColor}cert${AnsiEscape}  Explains  how to setup default certificate
                  ${HelpColor}all${AnsiEscape}   Displays all above

${HelpColor}-m --mode${AnsiEscape}         Mode for displaying

                  ${HelpColor}raw${AnsiEscape}      Displays basic VHOST at port 80
                  ${HelpColor}markdown${AnsiEscape} Displays SSL VHOST at port 443 and explains how to create certificate files
                  if not set default with colors

${HelpColor}-i --interactive${AnsiEscape}  If interactive is enabled longer samples will be displayed one-by-one with brake for coffee
${HelpColor}--muted${AnsiEscape}           If muted most instructions will be disabled code will be shown only${CodeBlockEsc}

${Header3H3}Shortcuts:

If you just want to generate vhosts and/or certivicates, just use these shortcuts (muted)

${CodeBlock}${HelpColor}--vhost${AnsiEscape}           Gets two unnamed params, domain and root, see samples
${HelpColor}--vhost-ssl${AnsiEscape}       Same as above, but shows SSL vhost
${HelpColor}--cert-ssl${AnsiEscape}        Same as above, but shows certificate generation${CodeBlockEsc}

${Header3H3}Samples:

${CodeBlock}${CodeColor}vhost-template.sh  -d my-project-1.loc -r /www/projects/my-project-1.loc$ --topic all --interactive ${AnsiEscape}${CodeBlockEsc}

${Header4}These three will show ready to use vhosts + certificates

${CodeBlock}${CodeColor}vhost-template.sh  --muted --vhost     foo.loc /www/projects/foo${AnsiEscape}
${CodeColor}vhost-template.sh  --muted --vhost-ssl foo.loc /www/projects/foo${AnsiEscape}
${CodeColor}vhost-template.sh  --muted --cert-ssl  foo.loc /www/projects/foo${AnsiEscape}${CodeBlockEsc}
"
}

setDefaultStyle

domainIsSet=false
rootIsSet=false
while :; do
  case $1 in
  -h | -\? | --help)
    showHelp # Display a usage synopsis.
    exit
    ;;

  --vhost)
    if [ "$2" ] && [ "$3" ]; then
      DOMAIN=$2
      ROOT=$3
      renderBasic_0
      shift
      exit
    else
      die 'ERROR: "--vhost" requires two non-empty option arguments.'
    fi
    ;;

  --vhost-ssl)
    if [ "$2" ] && [ "$3" ]; then
      DOMAIN=$2
      ROOT=$3
      renderSSL_1
      shift
      exit
    else
      die 'ERROR: "--vhost-ssl" requires two non-empty option arguments.'
    fi
    ;;
  --cert-ssl)
    if [ "$2" ] && [ "$3" ]; then
      DOMAIN=$2
      ROOT=$3
      renderCerts_2
      shift
      exit
    else
      die 'ERROR: "--cert-ssl" requires two non-empty option arguments.'
    fi
    ;;
  -i | --interactive)
    INTERACTIVE=true
    ;;
  --muted)
    MUTED=true
    ;;
  --unmuted)
    MUTED=false
    echo $MUTED
    ;;
  -d | --domain) # Takes an option argument; ensure it has been specified.
    if [ "$2" ]; then
      DOMAIN=$2
      domainIsSet=true
      shift
    else
      die 'ERROR: "--domain" requires a non-empty option argument.'
    fi
    ;;
  -r | --root) # Takes an option argument; ensure it has been specified.
    if [ "$2" ]; then
      ROOT=$2
      rootIsSet=true
      shift
    else
      die 'ERROR: "--root" requires a non-empty option argument.'
    fi
    ;;
  -t | --topic) # Takes an option argument; ensure it has been specified.
    if [ "$2" ]; then
      case "$2" in
      "basic") TOPIC=basic ;;
      "ssl") TOPIC=ssl ;;
      "cert") TOPIC=cert ;;
      "all") TOPIC=all ;;
      *) #default topic set earlier
        ;;
      esac

      shift
    else
      die 'ERROR: "--mode" requires a non-empty option argument.'
    fi
    ;;
  -m | --mode) # Takes an option argument; ensure it has been specified.
    if [ "$2" ]; then
      case "$2" in
      "raw") setRawStyle ;;
      "markdown") setMarkdownStyle ;;
      *) setDefaultStyle ;;
      esac

      shift
    else
      die 'ERROR: "--mode" requires a non-empty option argument. `raw`, `markdown` or none allowed'
    fi
    ;;
  --) # End of all options.
    shift
    break
    ;;
  -?*)
    printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
    ;;
  *) # Default case: No more options, so break out of the loop.
    break
    ;;
  esac

  shift
done

if [ $domainIsSet = false ] || [ $rootIsSet = false ]; then
  pressAnyKeyToFinish
  die "ERROR: Params: --domain (-d) and --root (-r) must be always settt

see documentation for details using vhost-template.sh  -h
  "

fi

if [ $INTERACTIVE = true ]; then
  clearConsole
fi

case $TOPIC in
basic)
  renderBasic_0
  pressEnterToContinue
  suggestOtherTopics
  pressAnyKeyToFinish
  sayGoodBye
  ;;
ssl)
  renderSSL_1
  pressEnterToContinue
  suggestOtherTopics
  pressAnyKeyToFinish
  sayGoodBye
  ;;
cert)
  renderCerts_2
  pressEnterToContinue
  renderDefaultCert_3
  pressEnterToContinue
  suggestOtherTopics
  pressAnyKeyToFinish
  sayGoodBye
  ;;
all)
  renderBasic_0
  pressEnterToContinue
  renderSSL_1
  pressEnterToContinue
  renderCerts_2
  pressEnterToContinue
  renderDefaultCert_3
  pressEnterToContinue
  suggestOtherTopics
  pressAnyKeyToFinish
  sayGoodBye
  ;;
*) ;;

esac

if [ $INTERACTIVE = true ]; then
  echo "That's all, you used interactive mode, but can still see what was done by scrolling up. ciao :*"
fi
