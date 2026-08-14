FROM ubuntu:26.04 AS source

ADD --checksum=sha256:fa98b608532dfbbbb2b0931483aac41e57fb19c175a2cc7bd7d528d5e0fbb287 https://github.com/bambulab/BambuStudio/releases/download/v02.07.01.62/BambuStudio_ubuntu24.04-v02.07.01.62-20260616195227.AppImage /tmp/source

RUN chmod 0755 /tmp/source && \
    cd /tmp && \
    ./source --appimage-extract >/dev/null && \
    mv /tmp/squashfs-root /out

FROM ghcr.io/containerpak/webkitgtk:main

COPY --from=source /out /opt/bambu-studio
COPY icon.png /usr/share/icons/hicolor/128x128/apps/bambu-studio.png

RUN mkdir -p /usr/share/applications && \
    printf '#!/bin/sh\nexec /opt/bambu-studio/AppRun "$@"\n' > /usr/bin/bambu-studio && \
    chmod 0755 /usr/bin/bambu-studio && \
    printf '[Desktop Entry]\nName=Bambu Studio\nExec=bambu-studio %F\nIcon=bambu-studio\nType=Application\nCategories=Graphics;3DGraphics;\n' > /usr/share/applications/com.bambulab.BambuStudio.desktop && \
    cpak-clean-junk
