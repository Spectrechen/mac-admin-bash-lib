#!/usr/bin/env bash
# maclib.sh - entrypoint to source all modules

# Compute the library directory once (avoids forking a subshell per
# source line). Modules are referenced as "$LIB_DIR/<module>.sh".
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/log.sh
source "$LIB_DIR/log.sh"
# shellcheck source=lib/os.sh
source "$LIB_DIR/os.sh"
# shellcheck source=lib/user.sh
source "$LIB_DIR/user.sh"
# shellcheck source=lib/system.sh
source "$LIB_DIR/system.sh"
# shellcheck source=lib/packages.sh
source "$LIB_DIR/packages.sh"
# shellcheck source=lib/signing.sh
source "$LIB_DIR/signing.sh"
# shellcheck source=lib/keychain.sh
source "$LIB_DIR/keychain.sh"
# shellcheck source=lib/launchd.sh
source "$LIB_DIR/launchd.sh"
# shellcheck source=lib/filevault.sh
source "$LIB_DIR/filevault.sh"
# shellcheck source=lib/security.sh
source "$LIB_DIR/security.sh"
# shellcheck source=lib/management.sh
source "$LIB_DIR/management.sh"
# shellcheck source=lib/network.sh
source "$LIB_DIR/network.sh"
# shellcheck source=lib/app.sh
source "$LIB_DIR/app.sh"
# shellcheck source=lib/office.sh
source "$LIB_DIR/office.sh"
# shellcheck source=lib/chrome.sh
source "$LIB_DIR/chrome.sh"
# shellcheck source=lib/firefox.sh
source "$LIB_DIR/firefox.sh"
# shellcheck source=lib/zoom.sh
source "$LIB_DIR/zoom.sh"
# shellcheck source=lib/1password.sh
source "$LIB_DIR/1password.sh"
# shellcheck source=lib/slack.sh
source "$LIB_DIR/slack.sh"
# shellcheck source=lib/dropbox.sh
source "$LIB_DIR/dropbox.sh"
# shellcheck source=lib/notion.sh
source "$LIB_DIR/notion.sh"
# shellcheck source=lib/vlc.sh
source "$LIB_DIR/vlc.sh"
# shellcheck source=lib/signal.sh
source "$LIB_DIR/signal.sh"
# shellcheck source=lib/libreoffice.sh
source "$LIB_DIR/libreoffice.sh"
# shellcheck source=lib/iterm2.sh
source "$LIB_DIR/iterm2.sh"
# shellcheck source=lib/figma.sh
source "$LIB_DIR/figma.sh"
# shellcheck source=lib/chatgpt.sh
source "$LIB_DIR/chatgpt.sh"
# shellcheck source=lib/jamf.sh
source "$LIB_DIR/jamf.sh"

# shellcheck source=lib/4kvideodownloader.sh
source "$LIB_DIR/4kvideodownloader.sh"
# shellcheck source=lib/4kvideodownloaderplus.sh
source "$LIB_DIR/4kvideodownloaderplus.sh"
# shellcheck source=lib/8x8.sh
source "$LIB_DIR/8x8.sh"
# shellcheck source=lib/abetterfinderattributes7.sh
source "$LIB_DIR/abetterfinderattributes7.sh"
# shellcheck source=lib/abetterfinderrename11.sh
source "$LIB_DIR/abetterfinderrename11.sh"
# shellcheck source=lib/abetterfinderrename12.sh
source "$LIB_DIR/abetterfinderrename12.sh"
# shellcheck source=lib/abletonlive12intro.sh
source "$LIB_DIR/abletonlive12intro.sh"
# shellcheck source=lib/abletonlive12lite.sh
source "$LIB_DIR/abletonlive12lite.sh"
# shellcheck source=lib/abletonlive12standard.sh
source "$LIB_DIR/abletonlive12standard.sh"
# shellcheck source=lib/abletonlive12suite.sh
source "$LIB_DIR/abletonlive12suite.sh"
# shellcheck source=lib/abletonlive12trial.sh
source "$LIB_DIR/abletonlive12trial.sh"
# shellcheck source=lib/abstract.sh
source "$LIB_DIR/abstract.sh"
# shellcheck source=lib/acorn.sh
source "$LIB_DIR/acorn.sh"
# shellcheck source=lib/acroniscyberprotectconnect.sh
source "$LIB_DIR/acroniscyberprotectconnect.sh"
# shellcheck source=lib/acroniscyberprotectconnectagent.sh
source "$LIB_DIR/acroniscyberprotectconnectagent.sh"
# shellcheck source=lib/adium.sh
source "$LIB_DIR/adium.sh"
# shellcheck source=lib/adobeacrobatprodc.sh
source "$LIB_DIR/adobeacrobatprodc.sh"
# shellcheck source=lib/adobebrackets.sh
source "$LIB_DIR/adobebrackets.sh"
# shellcheck source=lib/adobeconnect.sh
source "$LIB_DIR/adobeconnect.sh"
# shellcheck source=lib/adobecreativeclouddesktop.sh
source "$LIB_DIR/adobecreativeclouddesktop.sh"
# shellcheck source=lib/adobereaderdc.sh
source "$LIB_DIR/adobereaderdc.sh"
# shellcheck source=lib/adobereaderdc-install.sh
source "$LIB_DIR/adobereaderdc-install.sh"
# shellcheck source=lib/adobereaderdc-update.sh
source "$LIB_DIR/adobereaderdc-update.sh"
# shellcheck source=lib/aftermath.sh
source "$LIB_DIR/aftermath.sh"
# shellcheck source=lib/airflow.sh
source "$LIB_DIR/airflow.sh"
# shellcheck source=lib/airserver.sh
source "$LIB_DIR/airserver.sh"
# shellcheck source=lib/aldente.sh
source "$LIB_DIR/aldente.sh"
# shellcheck source=lib/alephone.sh
source "$LIB_DIR/alephone.sh"
# shellcheck source=lib/alfred.sh
source "$LIB_DIR/alfred.sh"
# shellcheck source=lib/altserver.sh
source "$LIB_DIR/altserver.sh"
# shellcheck source=lib/alttab.sh
source "$LIB_DIR/alttab.sh"
# shellcheck source=lib/amazoncorretto11jdk.sh
source "$LIB_DIR/amazoncorretto11jdk.sh"
# shellcheck source=lib/amazoncorretto17jdk.sh
source "$LIB_DIR/amazoncorretto17jdk.sh"
# shellcheck source=lib/amazoncorretto21jdk.sh
source "$LIB_DIR/amazoncorretto21jdk.sh"
# shellcheck source=lib/amazoncorretto22jdk.sh
source "$LIB_DIR/amazoncorretto22jdk.sh"
# shellcheck source=lib/amazoncorretto23jdk.sh
source "$LIB_DIR/amazoncorretto23jdk.sh"
# shellcheck source=lib/amazoncorretto25jdk.sh
source "$LIB_DIR/amazoncorretto25jdk.sh"
# shellcheck source=lib/amazoncorretto8jdk.sh
source "$LIB_DIR/amazoncorretto8jdk.sh"
# shellcheck source=lib/amazonq.sh
source "$LIB_DIR/amazonq.sh"
# shellcheck source=lib/amazonworkspaces.sh
source "$LIB_DIR/amazonworkspaces.sh"
# shellcheck source=lib/anastasiysextensionmanager.sh
source "$LIB_DIR/anastasiysextensionmanager.sh"
# shellcheck source=lib/androidfiletransfer.sh
source "$LIB_DIR/androidfiletransfer.sh"
# shellcheck source=lib/anki.sh
source "$LIB_DIR/anki.sh"
# shellcheck source=lib/antconc.sh
source "$LIB_DIR/antconc.sh"
# shellcheck source=lib/apachedirectorystudio.sh
source "$LIB_DIR/apachedirectorystudio.sh"
# shellcheck source=lib/ape.sh
source "$LIB_DIR/ape.sh"
# shellcheck source=lib/apparency.sh
source "$LIB_DIR/apparency.sh"
# shellcheck source=lib/appcleaner.sh
source "$LIB_DIR/appcleaner.sh"
# shellcheck source=lib/applenyfonts.sh
source "$LIB_DIR/applenyfonts.sh"
# shellcheck source=lib/appleprovideoformats.sh
source "$LIB_DIR/appleprovideoformats.sh"
# shellcheck source=lib/applesfarabic.sh
source "$LIB_DIR/applesfarabic.sh"
# shellcheck source=lib/applesfcompact.sh
source "$LIB_DIR/applesfcompact.sh"
# shellcheck source=lib/applesfmono.sh
source "$LIB_DIR/applesfmono.sh"
# shellcheck source=lib/applesfpro.sh
source "$LIB_DIR/applesfpro.sh"
# shellcheck source=lib/applesfsymbols.sh
source "$LIB_DIR/applesfsymbols.sh"
# shellcheck source=lib/appsanywhere.sh
source "$LIB_DIR/appsanywhere.sh"
# shellcheck source=lib/aquamacs.sh
source "$LIB_DIR/aquamacs.sh"
# shellcheck source=lib/aquaskk.sh
source "$LIB_DIR/aquaskk.sh"
# shellcheck source=lib/arcbrowser.sh
source "$LIB_DIR/arcbrowser.sh"
# shellcheck source=lib/archaeology.sh
source "$LIB_DIR/archaeology.sh"
# shellcheck source=lib/archimate.sh
source "$LIB_DIR/archimate.sh"
# shellcheck source=lib/archiwareb2go.sh
source "$LIB_DIR/archiwareb2go.sh"
# shellcheck source=lib/archiwarepst.sh
source "$LIB_DIR/archiwarepst.sh"
# shellcheck source=lib/arduinoide.sh
source "$LIB_DIR/arduinoide.sh"
# shellcheck source=lib/arq7.sh
source "$LIB_DIR/arq7.sh"
# shellcheck source=lib/arturiamcc.sh
source "$LIB_DIR/arturiamcc.sh"
# shellcheck source=lib/arturiasoftwarecenter.sh
source "$LIB_DIR/arturiasoftwarecenter.sh"
# shellcheck source=lib/asana.sh
source "$LIB_DIR/asana.sh"
# shellcheck source=lib/aspera.sh
source "$LIB_DIR/aspera.sh"
# shellcheck source=lib/asperaconnect.sh
source "$LIB_DIR/asperaconnect.sh"
# shellcheck source=lib/asymmetrickeygenerator.sh
source "$LIB_DIR/asymmetrickeygenerator.sh"
# shellcheck source=lib/atlassiancompanion.sh
source "$LIB_DIR/atlassiancompanion.sh"
# shellcheck source=lib/audacity.sh
source "$LIB_DIR/audacity.sh"
# shellcheck source=lib/autodmg.sh
source "$LIB_DIR/autodmg.sh"
# shellcheck source=lib/automounter.sh
source "$LIB_DIR/automounter.sh"
# shellcheck source=lib/autopkgr.sh
source "$LIB_DIR/autopkgr.sh"
# shellcheck source=lib/avertouch.sh
source "$LIB_DIR/avertouch.sh"
# shellcheck source=lib/aviatrix.sh
source "$LIB_DIR/aviatrix.sh"
# shellcheck source=lib/awscli2.sh
source "$LIB_DIR/awscli2.sh"
# shellcheck source=lib/awsvpnclient.sh
source "$LIB_DIR/awsvpnclient.sh"
# shellcheck source=lib/axurerp10.sh
source "$LIB_DIR/axurerp10.sh"
# shellcheck source=lib/azuredatastudio.sh
source "$LIB_DIR/azuredatastudio.sh"
# shellcheck source=lib/backgroundmusic.sh
source "$LIB_DIR/backgroundmusic.sh"
# shellcheck source=lib/backgrounds.sh
source "$LIB_DIR/backgrounds.sh"
# shellcheck source=lib/balenaetcher.sh
source "$LIB_DIR/balenaetcher.sh"
# shellcheck source=lib/balsamiqwireframes.sh
source "$LIB_DIR/balsamiqwireframes.sh"
# shellcheck source=lib/bambustudio.sh
source "$LIB_DIR/bambustudio.sh"
# shellcheck source=lib/bartender.sh
source "$LIB_DIR/bartender.sh"
# shellcheck source=lib/basecamp3.sh
source "$LIB_DIR/basecamp3.sh"
# shellcheck source=lib/baseline.sh
source "$LIB_DIR/baseline.sh"
# shellcheck source=lib/baseline-nodaemon.sh
source "$LIB_DIR/baseline-nodaemon.sh"
# shellcheck source=lib/bbedit.sh
source "$LIB_DIR/bbedit.sh"
# shellcheck source=lib/bbeditpkg.sh
source "$LIB_DIR/bbeditpkg.sh"
# shellcheck source=lib/beamstudio.sh
source "$LIB_DIR/beamstudio.sh"
# shellcheck source=lib/beekeeperstudio.sh
source "$LIB_DIR/beekeeperstudio.sh"
# shellcheck source=lib/betterdisplay.sh
source "$LIB_DIR/betterdisplay.sh"
# shellcheck source=lib/bettertouchtool.sh
source "$LIB_DIR/bettertouchtool.sh"
# shellcheck source=lib/betterzip.sh
source "$LIB_DIR/betterzip.sh"
# shellcheck source=lib/beyondcomparepro.sh
source "$LIB_DIR/beyondcomparepro.sh"
# shellcheck source=lib/bezel.sh
source "$LIB_DIR/bezel.sh"
# shellcheck source=lib/bibdesk.sh
source "$LIB_DIR/bibdesk.sh"
# shellcheck source=lib/bitrix24.sh
source "$LIB_DIR/bitrix24.sh"
# shellcheck source=lib/bitwarden.sh
source "$LIB_DIR/bitwarden.sh"
# shellcheck source=lib/bitwigstudio.sh
source "$LIB_DIR/bitwigstudio.sh"
# shellcheck source=lib/blackhole16ch.sh
source "$LIB_DIR/blackhole16ch.sh"
# shellcheck source=lib/blackhole2ch.sh
source "$LIB_DIR/blackhole2ch.sh"
# shellcheck source=lib/blackhole64ch.sh
source "$LIB_DIR/blackhole64ch.sh"
# shellcheck source=lib/blitzit.sh
source "$LIB_DIR/blitzit.sh"
# shellcheck source=lib/boop.sh
source "$LIB_DIR/boop.sh"
# shellcheck source=lib/boxdrive.sh
source "$LIB_DIR/boxdrive.sh"
# shellcheck source=lib/boxsync.sh
source "$LIB_DIR/boxsync.sh"
# shellcheck source=lib/boxtools.sh
source "$LIB_DIR/boxtools.sh"
# shellcheck source=lib/bracketsio.sh
source "$LIB_DIR/bracketsio.sh"
# shellcheck source=lib/brave.sh
source "$LIB_DIR/brave.sh"
# shellcheck source=lib/bravepkg.sh
source "$LIB_DIR/bravepkg.sh"
# shellcheck source=lib/brosix.sh
source "$LIB_DIR/brosix.sh"
# shellcheck source=lib/browserosaurus.sh
source "$LIB_DIR/browserosaurus.sh"
# shellcheck source=lib/bruno.sh
source "$LIB_DIR/bruno.sh"
# shellcheck source=lib/bugdom.sh
source "$LIB_DIR/bugdom.sh"
# shellcheck source=lib/burpsuiteprofessional.sh
source "$LIB_DIR/burpsuiteprofessional.sh"
# shellcheck source=lib/busycal.sh
source "$LIB_DIR/busycal.sh"
# shellcheck source=lib/busycontacts.sh
source "$LIB_DIR/busycontacts.sh"
# shellcheck source=lib/buttercup.sh
source "$LIB_DIR/buttercup.sh"
# shellcheck source=lib/caffeine.sh
source "$LIB_DIR/caffeine.sh"
# shellcheck source=lib/cakebrew.sh
source "$LIB_DIR/cakebrew.sh"
# shellcheck source=lib/calcservice.sh
source "$LIB_DIR/calcservice.sh"
# shellcheck source=lib/calibre.sh
source "$LIB_DIR/calibre.sh"
# shellcheck source=lib/calibriteprofiler.sh
source "$LIB_DIR/calibriteprofiler.sh"
# shellcheck source=lib/cameracontroller.sh
source "$LIB_DIR/cameracontroller.sh"
# shellcheck source=lib/camostudio.sh
source "$LIB_DIR/camostudio.sh"
# shellcheck source=lib/camunda.sh
source "$LIB_DIR/camunda.sh"
# shellcheck source=lib/canva.sh
source "$LIB_DIR/canva.sh"
# shellcheck source=lib/carboncopycloner.sh
source "$LIB_DIR/carboncopycloner.sh"
# shellcheck source=lib/cardpresso.sh
source "$LIB_DIR/cardpresso.sh"
# shellcheck source=lib/catoclient.sh
source "$LIB_DIR/catoclient.sh"
# shellcheck source=lib/charles.sh
source "$LIB_DIR/charles.sh"
# shellcheck source=lib/chatwork.sh
source "$LIB_DIR/chatwork.sh"
# shellcheck source=lib/chemdoodle.sh
source "$LIB_DIR/chemdoodle.sh"
# shellcheck source=lib/chemdoodle2d.sh
source "$LIB_DIR/chemdoodle2d.sh"
# shellcheck source=lib/chemdoodle3d.sh
source "$LIB_DIR/chemdoodle3d.sh"
# shellcheck source=lib/cherryaudioblue3.sh
source "$LIB_DIR/cherryaudioblue3.sh"
# shellcheck source=lib/cherryaudioca2600.sh
source "$LIB_DIR/cherryaudioca2600.sh"
# shellcheck source=lib/cherryaudiochroma.sh
source "$LIB_DIR/cherryaudiochroma.sh"
# shellcheck source=lib/cherryaudiocr78.sh
source "$LIB_DIR/cherryaudiocr78.sh"
# shellcheck source=lib/cherryaudiodco106.sh
source "$LIB_DIR/cherryaudiodco106.sh"
# shellcheck source=lib/cherryaudiodreamsynth.sh
source "$LIB_DIR/cherryaudiodreamsynth.sh"
# shellcheck source=lib/cherryaudioeightvoice.sh
source "$LIB_DIR/cherryaudioeightvoice.sh"
# shellcheck source=lib/cherryaudioelkax.sh
source "$LIB_DIR/cherryaudioelkax.sh"
# shellcheck source=lib/cherryaudiogalacticreverb.sh
source "$LIB_DIR/cherryaudiogalacticreverb.sh"
# shellcheck source=lib/cherryaudiogx80.sh
source "$LIB_DIR/cherryaudiogx80.sh"
