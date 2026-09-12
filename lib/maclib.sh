#!/usr/bin/env bash
# maclib.sh - entrypoint to source all modules

# Compute the library directory once (avoids forking a subshell per
# source line). Modules are referenced as "$LIB_DIR/<subdir>/<module>.sh".
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# core modules
# shellcheck source=lib/core/app.sh
source "$LIB_DIR/core/app.sh"
# shellcheck source=lib/core/filevault.sh
source "$LIB_DIR/core/filevault.sh"
# shellcheck source=lib/core/keychain.sh
source "$LIB_DIR/core/keychain.sh"
# shellcheck source=lib/core/launchd.sh
source "$LIB_DIR/core/launchd.sh"
# shellcheck source=lib/core/log.sh
source "$LIB_DIR/core/log.sh"
# shellcheck source=lib/core/management.sh
source "$LIB_DIR/core/management.sh"
# shellcheck source=lib/core/network.sh
source "$LIB_DIR/core/network.sh"
# shellcheck source=lib/core/os.sh
source "$LIB_DIR/core/os.sh"
# shellcheck source=lib/core/packages.sh
source "$LIB_DIR/core/packages.sh"
# shellcheck source=lib/core/signing.sh
source "$LIB_DIR/core/signing.sh"
# shellcheck source=lib/core/system.sh
source "$LIB_DIR/core/system.sh"
# shellcheck source=lib/core/user.sh
source "$LIB_DIR/core/user.sh"

# security modules
# shellcheck source=lib/security/security.sh
source "$LIB_DIR/security/security.sh"

# mdm modules
# shellcheck source=lib/mdm/jamf.sh
source "$LIB_DIR/mdm/jamf.sh"

# browsers modules
# shellcheck source=lib/browsers/chrome.sh
source "$LIB_DIR/browsers/chrome.sh"
# shellcheck source=lib/browsers/firefox.sh
source "$LIB_DIR/browsers/firefox.sh"

# communication modules
# shellcheck source=lib/communication/signal.sh
source "$LIB_DIR/communication/signal.sh"
# shellcheck source=lib/communication/slack.sh
source "$LIB_DIR/communication/slack.sh"
# shellcheck source=lib/communication/zoom.sh
source "$LIB_DIR/communication/zoom.sh"

# productivity modules
# shellcheck source=lib/productivity/libreoffice.sh
source "$LIB_DIR/productivity/libreoffice.sh"
# shellcheck source=lib/productivity/notion.sh
source "$LIB_DIR/productivity/notion.sh"
# shellcheck source=lib/productivity/office.sh
source "$LIB_DIR/productivity/office.sh"

# media modules
# shellcheck source=lib/media/vlc.sh
source "$LIB_DIR/media/vlc.sh"

# ai modules
# shellcheck source=lib/ai/chatgpt.sh
source "$LIB_DIR/ai/chatgpt.sh"

# creative modules
# shellcheck source=lib/creative/figma.sh
source "$LIB_DIR/creative/figma.sh"

# devops modules
# shellcheck source=lib/devops/iterm2.sh
source "$LIB_DIR/devops/iterm2.sh"

# cloud_storage modules
# shellcheck source=lib/cloud_storage/dropbox.sh
source "$LIB_DIR/cloud_storage/dropbox.sh"

# security_tools modules
# shellcheck source=lib/security_tools/1password.sh
source "$LIB_DIR/security_tools/1password.sh"

# misc app modules (first letter '4')
# DRAFT, not loaded: source "$LIB_DIR/apps/4/4kvideodownloader.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/4/4kvideodownloaderplus.sh"

# misc app modules (first letter '8')
# DRAFT, not loaded: source "$LIB_DIR/apps/8/8x8.sh"

# misc app modules (first letter 'a')
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abetterfinderattributes7.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abetterfinderrename11.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abetterfinderrename12.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abletonlive12intro.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abletonlive12lite.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abletonlive12standard.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abletonlive12suite.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abletonlive12trial.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/abstract.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/acorn.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/acroniscyberprotectconnect.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/acroniscyberprotectconnectagent.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adium.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobeacrobatprodc.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobebrackets.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobeconnect.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobecreativeclouddesktop.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobereaderdc.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobereaderdc-install.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/adobereaderdc-update.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/aftermath.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/airflow.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/airserver.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/aldente.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/alephone.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/alfred.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/altserver.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/alttab.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto11jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto17jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto21jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto22jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto23jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto25jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazoncorretto8jdk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazonq.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/amazonworkspaces.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/anastasiysextensionmanager.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/androidfiletransfer.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/anki.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/antconc.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/apachedirectorystudio.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/ape.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/apparency.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/appcleaner.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/applenyfonts.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/appleprovideoformats.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/applesfarabic.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/applesfcompact.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/applesfmono.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/applesfpro.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/applesfsymbols.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/appsanywhere.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/aquamacs.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/aquaskk.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/arcbrowser.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/archaeology.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/archimate.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/archiwareb2go.sh"
# shellcheck source=lib/apps/a/archiwarepst.sh
source "$LIB_DIR/apps/a/archiwarepst.sh"
# shellcheck source=lib/apps/a/arduinoide.sh
source "$LIB_DIR/apps/a/arduinoide.sh"
# shellcheck source=lib/apps/a/arq7.sh
source "$LIB_DIR/apps/a/arq7.sh"
# shellcheck source=lib/apps/a/arturiamcc.sh
source "$LIB_DIR/apps/a/arturiamcc.sh"
# shellcheck source=lib/apps/a/arturiasoftwarecenter.sh
source "$LIB_DIR/apps/a/arturiasoftwarecenter.sh"
# shellcheck source=lib/apps/a/asana.sh
source "$LIB_DIR/apps/a/asana.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/a/aspera.sh"
# shellcheck source=lib/apps/a/asperaconnect.sh
source "$LIB_DIR/apps/a/asperaconnect.sh"
# shellcheck source=lib/apps/a/asymmetrickeygenerator.sh
source "$LIB_DIR/apps/a/asymmetrickeygenerator.sh"
# shellcheck source=lib/apps/a/atlassiancompanion.sh
source "$LIB_DIR/apps/a/atlassiancompanion.sh"
# shellcheck source=lib/apps/a/audacity.sh
source "$LIB_DIR/apps/a/audacity.sh"
# shellcheck source=lib/apps/a/autodmg.sh
source "$LIB_DIR/apps/a/autodmg.sh"
# shellcheck source=lib/apps/a/automounter.sh
source "$LIB_DIR/apps/a/automounter.sh"
# shellcheck source=lib/apps/a/autopkgr.sh
source "$LIB_DIR/apps/a/autopkgr.sh"
# shellcheck source=lib/apps/a/avertouch.sh
source "$LIB_DIR/apps/a/avertouch.sh"
# shellcheck source=lib/apps/a/aviatrix.sh
source "$LIB_DIR/apps/a/aviatrix.sh"
# shellcheck source=lib/apps/a/awscli2.sh
source "$LIB_DIR/apps/a/awscli2.sh"
# shellcheck source=lib/apps/a/awsvpnclient.sh
source "$LIB_DIR/apps/a/awsvpnclient.sh"
# shellcheck source=lib/apps/a/axurerp10.sh
source "$LIB_DIR/apps/a/axurerp10.sh"
# shellcheck source=lib/apps/a/azuredatastudio.sh
source "$LIB_DIR/apps/a/azuredatastudio.sh"

# misc app modules (first letter 'b')
# shellcheck source=lib/apps/b/backgroundmusic.sh
source "$LIB_DIR/apps/b/backgroundmusic.sh"
# shellcheck source=lib/apps/b/backgrounds.sh
source "$LIB_DIR/apps/b/backgrounds.sh"
# shellcheck source=lib/apps/b/balenaetcher.sh
source "$LIB_DIR/apps/b/balenaetcher.sh"
# shellcheck source=lib/apps/b/balsamiqwireframes.sh
source "$LIB_DIR/apps/b/balsamiqwireframes.sh"
# shellcheck source=lib/apps/b/bambustudio.sh
source "$LIB_DIR/apps/b/bambustudio.sh"
# shellcheck source=lib/apps/b/bartender.sh
source "$LIB_DIR/apps/b/bartender.sh"
# shellcheck source=lib/apps/b/basecamp3.sh
source "$LIB_DIR/apps/b/basecamp3.sh"
# shellcheck source=lib/apps/b/baseline.sh
source "$LIB_DIR/apps/b/baseline.sh"
# shellcheck source=lib/apps/b/baseline-nodaemon.sh
source "$LIB_DIR/apps/b/baseline-nodaemon.sh"
# shellcheck source=lib/apps/b/bbedit.sh
source "$LIB_DIR/apps/b/bbedit.sh"
# shellcheck source=lib/apps/b/bbeditpkg.sh
source "$LIB_DIR/apps/b/bbeditpkg.sh"
# shellcheck source=lib/apps/b/beamstudio.sh
source "$LIB_DIR/apps/b/beamstudio.sh"
# shellcheck source=lib/apps/b/beekeeperstudio.sh
source "$LIB_DIR/apps/b/beekeeperstudio.sh"
# shellcheck source=lib/apps/b/betterdisplay.sh
source "$LIB_DIR/apps/b/betterdisplay.sh"
# shellcheck source=lib/apps/b/bettertouchtool.sh
source "$LIB_DIR/apps/b/bettertouchtool.sh"
# shellcheck source=lib/apps/b/betterzip.sh
source "$LIB_DIR/apps/b/betterzip.sh"
# shellcheck source=lib/apps/b/beyondcomparepro.sh
source "$LIB_DIR/apps/b/beyondcomparepro.sh"
# shellcheck source=lib/apps/b/bezel.sh
source "$LIB_DIR/apps/b/bezel.sh"
# shellcheck source=lib/apps/b/bibdesk.sh
source "$LIB_DIR/apps/b/bibdesk.sh"
# shellcheck source=lib/apps/b/bitrix24.sh
source "$LIB_DIR/apps/b/bitrix24.sh"
# shellcheck source=lib/apps/b/bitwarden.sh
source "$LIB_DIR/apps/b/bitwarden.sh"
# shellcheck source=lib/apps/b/bitwigstudio.sh
source "$LIB_DIR/apps/b/bitwigstudio.sh"
# shellcheck source=lib/apps/b/blackhole16ch.sh
source "$LIB_DIR/apps/b/blackhole16ch.sh"
# shellcheck source=lib/apps/b/blackhole2ch.sh
source "$LIB_DIR/apps/b/blackhole2ch.sh"
# shellcheck source=lib/apps/b/blackhole64ch.sh
source "$LIB_DIR/apps/b/blackhole64ch.sh"
# shellcheck source=lib/apps/b/blitzit.sh
source "$LIB_DIR/apps/b/blitzit.sh"
# shellcheck source=lib/apps/b/boop.sh
source "$LIB_DIR/apps/b/boop.sh"
# shellcheck source=lib/apps/b/boxdrive.sh
source "$LIB_DIR/apps/b/boxdrive.sh"
# shellcheck source=lib/apps/b/boxsync.sh
source "$LIB_DIR/apps/b/boxsync.sh"
# shellcheck source=lib/apps/b/boxtools.sh
source "$LIB_DIR/apps/b/boxtools.sh"
# shellcheck source=lib/apps/b/bracketsio.sh
source "$LIB_DIR/apps/b/bracketsio.sh"
# shellcheck source=lib/apps/b/brave.sh
source "$LIB_DIR/apps/b/brave.sh"
# shellcheck source=lib/apps/b/bravepkg.sh
source "$LIB_DIR/apps/b/bravepkg.sh"
# shellcheck source=lib/apps/b/brosix.sh
source "$LIB_DIR/apps/b/brosix.sh"
# shellcheck source=lib/apps/b/browserosaurus.sh
source "$LIB_DIR/apps/b/browserosaurus.sh"
# shellcheck source=lib/apps/b/bruno.sh
source "$LIB_DIR/apps/b/bruno.sh"
# shellcheck source=lib/apps/b/bugdom.sh
source "$LIB_DIR/apps/b/bugdom.sh"
# shellcheck source=lib/apps/b/burpsuiteprofessional.sh
source "$LIB_DIR/apps/b/burpsuiteprofessional.sh"
# shellcheck source=lib/apps/b/busycal.sh
source "$LIB_DIR/apps/b/busycal.sh"
# shellcheck source=lib/apps/b/busycontacts.sh
source "$LIB_DIR/apps/b/busycontacts.sh"
# shellcheck source=lib/apps/b/buttercup.sh
source "$LIB_DIR/apps/b/buttercup.sh"

# misc app modules (first letter 'c')
# shellcheck source=lib/apps/c/caffeine.sh
source "$LIB_DIR/apps/c/caffeine.sh"
# shellcheck source=lib/apps/c/cakebrew.sh
source "$LIB_DIR/apps/c/cakebrew.sh"
# shellcheck source=lib/apps/c/calcservice.sh
source "$LIB_DIR/apps/c/calcservice.sh"
# shellcheck source=lib/apps/c/calibre.sh
source "$LIB_DIR/apps/c/calibre.sh"
# shellcheck source=lib/apps/c/calibriteprofiler.sh
source "$LIB_DIR/apps/c/calibriteprofiler.sh"
# shellcheck source=lib/apps/c/cameracontroller.sh
source "$LIB_DIR/apps/c/cameracontroller.sh"
# shellcheck source=lib/apps/c/camostudio.sh
source "$LIB_DIR/apps/c/camostudio.sh"
# shellcheck source=lib/apps/c/camunda.sh
source "$LIB_DIR/apps/c/camunda.sh"
# shellcheck source=lib/apps/c/canva.sh
source "$LIB_DIR/apps/c/canva.sh"
# shellcheck source=lib/apps/c/carboncopycloner.sh
source "$LIB_DIR/apps/c/carboncopycloner.sh"
# shellcheck source=lib/apps/c/cardpresso.sh
source "$LIB_DIR/apps/c/cardpresso.sh"
# shellcheck source=lib/apps/c/catoclient.sh
source "$LIB_DIR/apps/c/catoclient.sh"
# shellcheck source=lib/apps/c/charles.sh
source "$LIB_DIR/apps/c/charles.sh"
# shellcheck source=lib/apps/c/chatwork.sh
source "$LIB_DIR/apps/c/chatwork.sh"
# DRAFT, not loaded: source "$LIB_DIR/apps/c/chemdoodle.sh"
# shellcheck source=lib/apps/c/chemdoodle2d.sh
source "$LIB_DIR/apps/c/chemdoodle2d.sh"
# shellcheck source=lib/apps/c/chemdoodle3d.sh
source "$LIB_DIR/apps/c/chemdoodle3d.sh"
# shellcheck source=lib/apps/c/cherryaudioblue3.sh
source "$LIB_DIR/apps/c/cherryaudioblue3.sh"
# shellcheck source=lib/apps/c/cherryaudioca2600.sh
source "$LIB_DIR/apps/c/cherryaudioca2600.sh"
# shellcheck source=lib/apps/c/cherryaudiochroma.sh
source "$LIB_DIR/apps/c/cherryaudiochroma.sh"
# shellcheck source=lib/apps/c/cherryaudiocr78.sh
source "$LIB_DIR/apps/c/cherryaudiocr78.sh"
# shellcheck source=lib/apps/c/cherryaudiodco106.sh
source "$LIB_DIR/apps/c/cherryaudiodco106.sh"
# shellcheck source=lib/apps/c/cherryaudiodreamsynth.sh
source "$LIB_DIR/apps/c/cherryaudiodreamsynth.sh"
# shellcheck source=lib/apps/c/cherryaudioeightvoice.sh
source "$LIB_DIR/apps/c/cherryaudioeightvoice.sh"
# shellcheck source=lib/apps/c/cherryaudioelkax.sh
source "$LIB_DIR/apps/c/cherryaudioelkax.sh"
# shellcheck source=lib/apps/c/cherryaudiogalacticreverb.sh
source "$LIB_DIR/apps/c/cherryaudiogalacticreverb.sh"
# shellcheck source=lib/apps/c/cherryaudiogx80.sh
source "$LIB_DIR/apps/c/cherryaudiogx80.sh"
