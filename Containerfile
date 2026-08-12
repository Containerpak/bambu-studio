FROM ghcr.io/containerpak/gtk:main

ADD --checksum=sha256:fa98b608532dfbbbb2b0931483aac41e57fb19c175a2cc7bd7d528d5e0fbb287 https://github.com/bambulab/BambuStudio/releases/download/v02.07.01.62/BambuStudio_ubuntu24.04-v02.07.01.62-20260616195227.AppImage /tmp/source
COPY icon.png /usr/share/icons/hicolor/128x128/apps/bambu-studio.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends fuse3 libgl1 && \
    mkdir -p /opt/bambu-studio && install -m 0755 /tmp/source /opt/bambu-studio/BambuStudio.AppImage && printf '#!/bin/sh\nexec /opt/bambu-studio/BambuStudio.AppImage --appimage-extract-and-run "$@"\n' > /usr/bin/bambu-studio && chmod 0755 /usr/bin/bambu-studio && printf '[Desktop Entry]\nName=Bambu Studio\nExec=bambu-studio %F\nIcon=bambu-studio\nType=Application\nCategories=Graphics;3DGraphics;\n' > /usr/share/applications/com.bambulab.BambuStudio.desktop && \
    cpak-clean-junk
