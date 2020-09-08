# Help for `vhost-template.sh` ver.: `1.0.3`

© 2020 Marcus biesior Biesioroff

```
-h --help         To display this help
-d --domain       (required) name of the domain for this VHOST <ServerName>
-r --root         (required) name of the domain for this VHOST <DocumentRoot>
-t --topic        Topic to display, possible values

                  basic Displays basic VHOST at port 80
                  ssl   Displays SSL VHOST at port 443 and explains how to create certificate files
                  cert  Explains  how to setup default certificate
                  all   Displays all above

-m --mode         Mode for displaying

                  raw      Displays basic VHOST at port 80
                  markdown Displays SSL VHOST at port 443 and explains how to create certificate files
                  if not set default with colors

-i --interactive  If interactive is enabled longer samples will be displayed one-by-one with brake for coffee
--muted           If muted most instructions will be disabled code will be shown only
```

Shortcuts:

If you just want to generate vhosts and/or certivicates, just use these shortcuts (muted)

```
--vhost           Gets two unnamed params, domain and root, see samples
--vhost-ssl       Same as above, but shows SSL vhost
--cert-ssl        Same as above, but shows certificate generation
```

Samples:

```
vhost-template.sh  -d my-project-1.loc -r /www/projects/my-project-1.loc$ --topic all --interactive 
```

#### These three will show ready to use vhosts + certificates

```
vhost-template.sh  --muted --vhost     foo.loc /www/projects/foo
vhost-template.sh  --muted --vhost-ssl foo.loc /www/projects/foo
vhost-template.sh  --muted --cert-ssl  foo.loc /www/projects/foo
```

