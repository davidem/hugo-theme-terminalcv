#!/bin/bash

### cat /data/blog
### per regel:
## check if exist
## cat var
## cat commando

### vars
theme=$(awk -F "\"" '/theme:/{print $2}' ./hugo.yml)

## backup index.html
cp -f ./themes/terminalcv_v3/layouts/index.html ./themes/terminalcv_v3/layouts/index.bak

ls -1 ./data/blog | while read blogpost; do
  blogname=${blogpost%.*}

  ## check if already exists:
  if [[ $(awk '/cat_'"${blogname}"'/' ./themes/${theme}/layouts/index.html) = "" ]]; then # no entry

    new_var=" 
        var cat_${blogname} = [
      {{ range .Site.Data.blog }}
        {{ if eq .title \"${blogname}\" }}
          '\t{{ .title }}\n\n{{ .blogpost }}\n' +
        {{ end }}
      {{ end }}
      '\r'
    ];

    "

    new_command="
                    } else if (commands[1] == \"${blogname}\") {
                  echoArray(cat_${blogname});
                "

    ## add var
    sed '/cat variables marker/r'<(
      echo "${new_var}"
    ) ./themes/terminalcv_v3/layouts/index.html >/tmp/tmp_index.html

    ## add command
    sed '/cat command marker/r'<(
      echo "${new_command}"
    ) /tmp/tmp_index.html >./themes/terminalcv_v3/layouts/index.html
    rm /tmp/tmp_index.html

  else
    echo "${blogname} already in index.html"
  fi
done
