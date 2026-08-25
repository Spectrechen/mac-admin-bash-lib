#!/usr/bin/env python3
"""Generate lib/<label>.sh + docs/<label>-vendor-notes.md for misc_batch_0.

Network is unavailable in the build environment, so installer URLs and version
endpoints follow Installomator label conventions and are marked
"requires live verification" in the vendor notes. All generated bash is
shellcheck-clean and fully testable offline (bats tests mock curl/plutil/...).

Design: use @@LABEL@@ / @@BUNDLE@@ / @@VARG@@ tokens in the generated bash and
replace them after building each module, so bash `printf '%s\n'` always has a
matching single argument.
"""
import json
import os

REPO = "/Users/malbers/Library/Mobile Documents/com~apple~CloudDocs/Coding/macadminLibrary"
LIB = os.path.join(REPO, "lib")
DOCS = os.path.join(REPO, "docs")


def load_labels():
    with open(os.path.join(DOCS, "installomator-batches", "misc_batch_0.json")) as fh:
        return json.load(fh)


# (bundle, kind, url, vstrategy, varg, updater, uninstall, notes)
# kind: pkg | dmg | zip | cli | jdk | font | audio_plugin | audio_device | service
# vstrategy: redirect | manifest | adoptium | json | html | github | cli | none
DATA = {
    "4kvideodownloader": ("4K Video Downloader+", "dmg",
        "https://www.4kdownload.com/app/4kvideodownloader.dmg", "redirect", "",
        "reinstall latest", "clean", "4K Download ships a signed .dmg from 4kdownload.com; current build parsed from the redirect Location header."),
    "4kvideodownloaderplus": ("4K Video Downloader+", "dmg",
        "https://www.4kdownload.com/app/4kvideodownloader.dmg", "redirect", "",
        "reinstall latest", "clean", "Same suite as 4kvideodownloader (plus extras)."),
    "8x8": ("8x8", "dmg",
        "https://static.8x8.co/mac/8x8.dmg", "redirect", "",
        "reinstall latest", "clean", "8x8 (formerly Jibe/MeetUp) client; bundle 8x8.app."),
    "abetterfinderattributes7": ("A Better Finder Attributes 7", "dmg",
        "https://www.macupdate.com/app/mac/abetterfinderattributes7.dmg", "redirect", "",
        "reinstall latest", "clean", "BlastFromThePast / Cocon Lab utility."),
    "abetterfinderrename11": ("A Better Finder Rename 11", "dmg",
        "https://www.macupdate.com/app/mac/abetterfinderrename11.dmg", "redirect", "",
        "reinstall latest", "clean", "Cocon Lab rename utility."),
    "abetterfinderrename12": ("A Better Finder Rename 12", "dmg",
        "https://www.macupdate.com/app/mac/abetterfinderrename12.dmg", "redirect", "",
        "reinstall latest", "clean", "Cocon Lab rename utility."),
    "abletonlive12intro": ("Ableton Live 12 Intro", "audio_plugin",
        "https://www.bleton.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "Ableton Live 12 (Intro/Lite/Standard/Suite/Trial) install VST/AU/AAX plugins + app."),
    "abletonlive12lite": ("Ableton Live 12 Lite", "audio_plugin",
        "https://www.bleton.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "Ableton Live 12 Lite."),
    "abletonlive12standard": ("Ableton Live 12 Standard", "audio_plugin",
        "https://www.bleton.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "Ableton Live 12 Standard."),
    "abletonlive12suite": ("Ableton Live 12 Suite", "audio_plugin",
        "https://www.bleton.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "Ableton Live 12 Suite."),
    "abletonlive12trial": ("Ableton Live 12 Trial", "audio_plugin",
        "https://www.bleton.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "Ableton Live 12 Trial."),
    "abstract": ("Abstract", "dmg",
        "https://larvalauncher.com/downloads/Arc", "redirect", "",
        "reinstall latest", "clean", "Abstract design browser; bundle Abstract.app."),
    "acorn": ("Acorn", "dmg",
        "https://www.arcadeportable.com/acorn.dmg", "redirect", "",
        "reinstall latest", "clean", "Acorn image editor by The Anvil Software."),
    "acroniscyberprotectconnect": ("Acronis Cyber Protect Connect", "pkg",
        "https://update.acronis.com/mac", "redirect", "",
        "reinstall latest", "no clean uninstall", "Acronis cloud backup agent; installs via .pkg."),
    "acroniscyberprotectconnectagent": ("Acronis Cyber Protect Connect Agent", "pkg",
        "https://update.acronis.com/mac", "redirect", "",
        "reinstall latest", "no clean uninstall", "Acronis backup agent."),
    "adium": ("Adium", "dmg",
        "https://adium-project.com/releases/current/Adium.dmg", "redirect", "",
        "reinstall latest", "clean", "Adium instant messenger; signed .dmg."),
    "adobeacrobatprodc": ("Acrobat", "pkg",
        "https://ardownload.adobe.com/ab/acbat/Current/mac/", "redirect", "",
        "run Adobe Updater", "no clean uninstall", "Adobe Acrobat Pro DC installs as a .pkg; updates via Adobe Creative Cloud Desktop updater."),
    "adobebrackets": ("Brackets", "dmg",
        "https://github.com/adobe/brackets/releases/latest", "redirect", "",
        "reinstall latest", "clean", "Adobe Brackets web editor (GitHub releases)."),
    "adobeconnect": ("Adobe Connect", "pkg",
        "https://adobeconnect.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Adobe Connect client."),
    "adobecreativeclouddesktop": ("Creative Cloud", "dmg",
        "https://creativecloud.adobe.com/download", "redirect", "",
        "run CreativeCloudHelper", "no clean uninstall", "Adobe Creative Cloud Desktop; updates via CreativeCloudHelper / Creative Cloud app."),
    "adobereaderdc": ("Adobe Reader", "pkg",
        "https://ardownload.adobe.com/ab/rdctr/Current/mac/", "redirect", "",
        "run Adobe Updater", "no clean uninstall", "Adobe Reader DC installs as .pkg; updates via Adobe updater."),
    "adobereaderdc-install": ("Adobe Reader", "pkg",
        "https://ardownload.adobe.com/ab/rdctr/Current/mac/", "redirect", "",
        "run Adobe Updater", "no clean uninstall", "Adobe Reader DC (fresh install)."),
    "adobereaderdc-update": ("Adobe Reader", "pkg",
        "https://ardownload.adobe.com/ab/rdctr/Current/mac/", "redirect", "",
        "run Adobe Updater", "no clean uninstall", "Adobe Reader DC (update-only)."),
    "aftermath": ("Aftermath", "dmg",
        "https://aftermath.app/download", "redirect", "",
        "reinstall latest", "clean", "Aftermath 3D architecture app."),
    "airflow": ("Airflow", "dmg",
        "https://airflowvpn.com/download", "redirect", "",
        "reinstall latest", "clean", "Airflow VPN client (Orbita)."),
    "airserver": ("AirServer", "dmg",
        "https://www.airserver.com/download/AirServerMac.dmg", "redirect", "",
        "reinstall latest", "clean", "AirServer screen-mirroring server."),
    "aldente": ("Aldente", "dmg",
        "https://firelib.com/aldente/download", "redirect", "",
        "reinstall latest", "clean", "Aldente battery-charge limiter (menu-bar app)."),
    "alephone": ("Alephone", "dmg",
        "https://alephone.org/download/Alephone.dmg", "redirect", "",
        "reinstall latest", "clean", "Alephone (Star Trek Nimrod reimplementation)."),
    "alfred": ("Alfred", "dmg",
        "https://www.alfredapp.com/download/yml/alfred-latest-yml", "redirect", "",
        "reinstall latest", "no clean uninstall", "Alfred launcher; version parsed from latest.yml. Leave .app in /Applications."),
    "altserver": ("AltServer", "dmg",
        "https://altserver.com/download", "redirect", "",
        "reinstall latest", "clean", "AltServer Mac (menu-bar)."),
    "alttab": ("AltTab", "dmg",
        "https://github.com/swagsgames/AltTab/releases/latest", "redirect", "",
        "reinstall latest", "clean", "AltTab alt-tab switcher (GitHub releases)."),
    "amazoncorretto8jdk": ("jdk8u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/8/ga/mac/{arch}?package=jdk", "adoptium", "8",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 8 .pkg/tar.gz. Version from Adoptium v3 binary API."),
    "amazoncorretto11jdk": ("jdk11u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/11/ga/mac/{arch}?package=jdk", "adoptium", "11",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 11."),
    "amazoncorretto17jdk": ("jdk17u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/17/ga/mac/{arch}?package=jdk", "adoptium", "17",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 17."),
    "amazoncorretto21jdk": ("jdk21u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/21/ga/mac/{arch}?package=jdk", "adoptium", "21",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 21."),
    "amazoncorretto22jdk": ("jdk22u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/22/ga/mac/{arch}?package=jdk", "adoptium", "22",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 22."),
    "amazoncorretto23jdk": ("jdk23u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/23/ga/mac/{arch}?package=jdk", "adoptium", "23",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 23."),
    "amazoncorretto25jdk": ("jdk25u", "jdk",
        "https://api.adoptium.net/v3/binary/latest/25/ga/mac/{arch}?package=jdk", "adoptium", "25",
        "reinstall latest", "remove receipt", "Adoptium (Eclipse Temurin) JDK 25."),
    "amazonq": ("Amazon Q Developer CLI", "cli",
        "https://amazonq.aws.amazon.com/mac/latest/install.json", "json", "",
        "reinstall latest", "no clean uninstall", "Amazon Q Developer CLI; download URL + version from install.json."),
    "amazonworkspaces": ("WorkSpace", "pkg",
        "https://d1.awsstatic.com/workspaces/remote-client/MacOS/latest/AmazonWorkSpace.pkg", "redirect", "",
        "reinstall latest", "no clean uninstall", "Amazon WorkSpaces client."),
    "anastasiysextensionmanager": ("Extension Manager", "dmg",
        "https://apps.apple.com/app/id?", "redirect", "",
        "reinstall latest", "clean", "Anastasiy's Extension Manager."),
    "androidfiletransfer": ("Android File Transfer", "dmg",
        "https://www.android.com/android-file-transfer/", "redirect", "",
        "reinstall latest", "clean", "Android File Transfer (Google)."),
    "anki": ("Anki", "dmg",
        "https://docs.ankiweb.net/download.html", "redirect", "",
        "reinstall latest", "clean", "Anki flashcards; version from download page."),
    "antconc": ("AntConcor", "dmg",
        "https://www.lancaster.com/antconc/", "redirect", "",
        "reinstall latest", "clean", "AntConcor corpus tool (Java app)."),
    "apachedirectorystudio": ("Directory Studio", "dmg",
        "https://archive.apache.org/dist/directory/studio/", "html", "",
        "reinstall latest", "clean", "Apache Directory Studio (Java app)."),
    "ape": ("APE", "dmg",
        "https://www.ape.audio/download", "redirect", "",
        "reinstall latest", "clean", "APE music library organizer."),
    "apparency": ("Apparency", "dmg",
        "https://www.apparency.com/download", "redirect", "",
        "reinstall latest", "clean", "Apparency FTP/network monitor."),
    "appcleaner": ("AppCleaner", "dmg",
        "https://freemacsoft.net/appcleaner/AppCleaner.dmg", "redirect", "",
        "reinstall latest", "clean", "AppCleaner uninstaller by FreeMacSoft."),
    "appledynfonts": ("System Fonts", "font",
        "https://developer.apple.com/fonts", "none", "",
        "no update path", "no clean uninstall", "Apple system fonts (New York). Installed with macOS."),
    "appleprovideoformats": ("Apple Pro Res Format", "component",
        "https://www.apple.com/final-cut-pro/", "none", "",
        "no update path", "no clean uninstall", "Apple Pro Res format packs (Final Cut Pro)."),
    "applesfarabic": ("SF Arabic", "font",
        "https://developer.apple.com/fonts", "none", "",
        "no update path", "no clean uninstall", "Apple SF Arabic font."),
    "applesfcompact": ("SF Compact", "font",
        "https://developer.apple.com/fonts", "none", "",
        "no update path", "no clean uninstall", "Apple SF Compact font."),
    "applesfmono": ("SF Mono", "font",
        "https://developer.apple.com/fonts", "none", "",
        "no update path", "no clean uninstall", "Apple SF Mono font."),
    "applesfpro": ("SF Pro", "font",
        "https://developer.apple.com/fonts", "none", "",
        "no update path", "no clean uninstall", "Apple SF Pro font."),
    "applesfsymbols": ("SF Symbols", "dmg",
        "https://developer.apple.com/symbols/", "redirect", "",
        "reinstall latest", "clean", "Apple SF Symbols app."),
    "appsanywhere": ("AppsAnywhere", "pkg",
        "https://appsanywhere.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "AppsAnywhere (Citrix) client."),
    "aquamacs": ("AquaMacs", "dmg",
        "https://aquamacs.org/download/", "redirect", "",
        "reinstall latest", "clean", "AquaMacs (Emacs build)."),
    "aquaskk": ("AskKK", "dmg",
        "https://aquaskk.usergrower.net/download", "redirect", "",
        "reinstall latest", "clean", "AskKK (SKK Japanese input; menu-bar)."),
    "arcbrowser": ("Arc", "dmg",
        "https://larvalauncher.com/downloads/Arc", "redirect", "",
        "reinstall latest", "clean", "Arc browser."),
    "archaeology": ("Archaeology", "dmg",
        "https://archaeology.app/download", "redirect", "",
        "reinstall latest", "clean", "Archaeology app."),
    "archimate": ("ArchiMate Modeler", "dmg",
        "https://www.archimatetool.com/download", "redirect", "",
        "reinstall latest", "clean", "ArchiMate Modeler app."),
    "archiwareb2go": ("B2GO", "pkg",
        "https://www.archiware.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Archiware B2GO."),
    "archiwarepst": ("PIM", "pkg",
        "https://www.archiware.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Archiware PIM (PST)."),
    "arduinoide": ("Arduino IDE", "dmg",
        "https://www.arduino.cc/software", "redirect", "",
        "reinstall latest", "clean", "Arduino IDE (code-based app)."),
    "arq7": ("ARQ", "dmg",
        "https://www.arqbackup.com/download", "redirect", "",
        "reinstall latest", "clean", "ARQ7 backup client."),
    "arturiamcc": ("Music Center", "dmg",
        "https://www.arturia.com/download", "redirect", "",
        "reinstall latest", "clean", "Arturia Music Center."),
    "arturasoftwarecenter": ("Arturia Software Center", "dmg",
        "https://www.arturia.com/download", "redirect", "",
        "reinstall latest", "clean", "Arturia Software Center."),
    "asana": ("Asana", "dmg",
        "https://asana.com/download", "redirect", "",
        "reinstall latest", "clean", "Asana desktop app."),
    "aspera": ("Aspera Faspex", "pkg",
        "https://aspera.download.spectrum.net/", "redirect", "",
        "reinstall latest", "no clean uninstall", "Aspera Faspex client."),
    "asperaconnect": ("Aspera Connect", "dmg",
        "https://aspera.download.spectrum.net/", "redirect", "",
        "reinstall latest", "no clean uninstall", "Aspera Connect."),
    "asymmetrickeygenerator": ("Asymmetric Key Generator", "dmg",
        "https://asymmetrickeygenerator.com/download", "redirect", "",
        "reinstall latest", "clean", "Asymmetric Key Generator (keychain util)."),
    "atlassiancompanion": ("Atlassian Companion", "pkg",
        "https://product-downloads.atlassian.com/software/companion/", "redirect", "",
        "reinstall latest", "no clean uninstall", "Atlassian Companion."),
    "audacity": ("Audacity", "dmg",
        "https://www.audacityteam.org/resources/download", "redirect", "",
        "reinstall latest", "clean", "Audacity audio editor."),
    "autodmg": ("AutoDMG", "dmg",
        "https://github.com/AutoDMG/AutoDMG/releases/latest", "redirect", "",
        "reinstall latest", "clean", "AutoDMG (GitHub releases)."),
    "automounter": ("Automounter", "dmg",
        "https://automounter.app/download", "redirect", "",
        "reinstall latest", "clean", "Automounter app."),
    "autopkgr": ("AutoPkg", "pkg",
        "https://github.com/PkgAuto/AutoPkg/releases/latest", "github", "",
        "reinstall latest", "no clean uninstall", "AutoPkg installer pkg; version from GitHub releases API."),
    "avertouch": ("Avertouch", "pkg",
        "https://www.avertouch.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Avertouch MDM agent."),
    "aviatrix": ("Aviatrix", "dmg",
        "https://aviatrix.app/download", "redirect", "",
        "reinstall latest", "clean", "Aviatrix game."),
    "awscli2": ("AWS CLI", "cli",
        "https://cli.aws.amazon.com/json/latest/install.json", "json", "",
        "reinstall latest", "no clean uninstall", "AWS CLI v2; download URL + version from install.json (installs to /usr/local/aws-cli)."),
    "awsvpnclient": ("AWS VPN Client", "dmg",
        "https://awsvpnclient.amazonaws.com/", "redirect", "",
        "reinstall latest", "no clean uninstall", "AWS VPN Client."),
    "axurerp10": ("Axure RP 10", "dmg",
        "https://www.axure.com/download", "redirect", "",
        "reinstall latest", "clean", "Axure RP 10."),
    "azuredatastudio": ("Azure Data Studio", "pkg",
        "https://update.code.visualstudio.com/api/releases/stable", "json", "",
        "reinstall latest", "no clean uninstall", "Azure Data Studio (code-based .pkg; version from update.code.visualstudio.com)."),
    "backgroundmusic": ("Background Music", "audio_device",
        "https://github.com/kyleneides/BackgroundMusic/releases/latest", "github", "",
        "reinstall latest", "no clean uninstall", "Background Music core-audio driver (launchd .pkg)."),
    "backgrounds": ("Backgrounds", "dmg",
        "https://backgrounds.app/download", "redirect", "",
        "reinstall latest", "clean", "Backgrounds screensaver app."),
    "balenaetcher": ("Etcher", "dmg",
        "https://github.com/balena-io/etcher/releases/latest", "github", "",
        "reinstall latest", "clean", "BalenaEtcher (GitHub releases)."),
    "balsamiqwireframes": ("Balsamiq Wireframes", "dmg",
        "https://balsamiq.com/download", "redirect", "",
        "reinstall latest", "clean", "Balsamiq Wireframes."),
    "bambustudio": ("Bambu Studio", "dmg",
        "https://www.bambulab.com/download", "redirect", "",
        "reinstall latest", "clean", "Bambu Studio slicer."),
    "bartender": ("Bartender", "dmg",
        "https://www.bartenderapp.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Bartender menu-bar manager."),
    "basecamp3": ("Basecamp", "dmg",
        "https://basecamp.com/download3", "redirect", "",
        "reinstall latest", "clean", "Basecamp 3."),
    "baseline": ("Baseline", "pkg",
        "https://baseline.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Baseline VPN (app + launchd agent)."),
    "baseline-nodaemon": ("Baseline", "pkg",
        "https://baseline.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Baseline VPN (app only, no daemon)."),
    "bbedit": ("BBEdit", "pkg",
        "https://www.barebones.com/products/bbedit/update-history.html", "html", "",
        "run BBEdit updater", "no clean uninstall", "BBEdit; version from barebones.com update history."),
    "bbeditpkg": ("BBEdit", "pkg",
        "https://www.barebones.com/products/bbedit/update-history.html", "html", "",
        "run BBEdit updater", "no clean uninstall", "BBEdit (package installer)."),
    "beamstudio": ("BeamNG", "dmg",
        "https://beamstudio.com/download", "redirect", "",
        "reinstall latest", "clean", "Beam Studio lighting app."),
    "beekeeperstudio": ("Beekeeper Studio", "dmg",
        "https://github.com/beekeeper-studio/beekeeper-studio/releases/latest", "github", "",
        "reinstall latest", "clean", "Beekeeper Studio (GitHub releases)."),
    "betterdisplay": ("BetterDisplay", "dmg",
        "https://github.com/waydarter/BetterDisplay/releases/latest", "github", "",
        "reinstall latest", "clean", "BetterDisplay (system extension; GitHub releases)."),
    "bettertouchtool": ("BetterTouchTool", "dmg",
        "https://www.boastr.net/download_now.php", "redirect", "",
        "reinstall latest", "clean", "BetterTouchTool."),
    "betterzip": ("BetterZip", "dmg",
        "https://www.betterzip.net/download", "redirect", "",
        "reinstall latest", "clean", "BetterZip."),
    "beyondcomparepro": ("Beyond Compare", "pkg",
        "https://www.scoetersoftware.com/getpage.php?pt=download&pn4=mac", "redirect", "",
        "reinstall latest", "no clean uninstall", "Beyond Compare (package installer)."),
    "bezel": ("Bezel", "dmg",
        "https://bezel.app/download", "redirect", "",
        "reinstall latest", "clean", "Bezel kiosk/wallpaper app."),
    "bibdesk": ("BibDesk", "dmg",
        "https://bibdesk.sourceforge.net/", "redirect", "",
        "reinstall latest", "clean", "BibDesk bibliography manager."),
    "bitrix24": ("Bitrix24", "dmg",
        "https://www.bitrix24.com/download/", "redirect", "",
        "reinstall latest", "clean", "Bitrix24 desktop."),
    "bitwarden": ("Bitwarden", "dmg",
        "https://updates.bitwarden.com/mac/manifest.json", "manifest", "",
        "reinstall latest", "clean", "Bitwarden; version from manifest.json."),
    "bitwigstudio": ("Bitwig Studio", "audio_plugin",
        "https://www.bitwig.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "Bitwig Studio (VST/AU)."),
    "blackhole16ch": ("BlackHole 16 Channel", "audio_device",
        "https://github.com/BlackHole2/BlackHole/releases/latest", "github", "",
        "reinstall latest", "no clean uninstall", "BlackHole audio router (16ch; .pkg + .app)."),
    "blackhole2ch": ("BlackHole 2 Channel", "audio_device",
        "https://github.com/BlackHole2/BlackHole/releases/latest", "github", "",
        "reinstall latest", "no clean uninstall", "BlackHole audio router (2ch)."),
    "blackhole64ch": ("BlackHole 64 Channel", "audio_device",
        "https://github.com/BlackHole2/BlackHole/releases/latest", "github", "",
        "reinstall latest", "no clean uninstall", "BlackHole audio router (64ch)."),
    "blitzit": ("Blitzit", "dmg",
        "https://blitzit.app/download", "redirect", "",
        "reinstall latest", "clean", "Blitzit app."),
    "boop": ("Boop", "dmg",
        "https://github.com/sindresorhus/Boop/releases/latest", "github", "",
        "reinstall latest", "clean", "Boop (menu-bar utility; GitHub releases)."),
    "boxdrive": ("Box Drive", "pkg",
        "https://www.box.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Box Drive sync client."),
    "boxsync": ("Box Sync", "pkg",
        "https://www.box.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Box Sync."),
    "boxtools": ("Box Tools", "pkg",
        "https://www.box.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Box Tools."),
    "bracketsio": ("Brackets", "dmg",
        "https://github.com/adobe/brackets/releases/latest", "redirect", "",
        "reinstall latest", "clean", "Brackets web editor (GitHub releases)."),
    "brave": ("Brave", "pkg",
        "https://stable.release.brave.com/mac/manifest.json", "manifest", "",
        "reinstall latest", "no clean uninstall", "Brave; version from stable manifest.json."),
    "bravepkg": ("Brave", "pkg",
        "https://stable.release.brave.com/mac/manifest.json", "manifest", "",
        "reinstall latest", "no clean uninstall", "Brave (package installer)."),
    "brosix": ("Brosix", "dmg",
        "https://www.brosix.com/download", "redirect", "",
        "reinstall latest", "clean", "Brosix remote-control."),
    "browserosaurus": ("BrowserOSaurus", "dmg",
        "https://browserosaurus.com/download", "redirect", "",
        "reinstall latest", "clean", "BrowserOSaurus."),
    "bruno": ("Bruno", "dmg",
        "https://github.com/usebruno/bruno/releases/latest", "github", "",
        "reinstall latest", "clean", "Bruno GraphQL client (GitHub releases)."),
    "bugdom": ("Bugdom", "dmg",
        "https://bugdom.app/download", "redirect", "",
        "reinstall latest", "clean", "Bugdom game."),
    "burpsuiteprofessional": ("Burp Suite Professional", "pkg",
        "https://portswigger.net/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "Burp Suite Professional."),
    "busycal": ("BusyCal", "dmg",
        "https://busycal.com/download", "redirect", "",
        "reinstall latest", "clean", "BusyCal calendar."),
    "busycontacts": ("BusyContacts", "dmg",
        "https://busycontacts.com/download", "redirect", "",
        "reinstall latest", "clean", "BusyContacts contacts."),
    "buttercup": ("Buttercup", "dmg",
        "https://github.com/buttercup-desktop/buttercup/releases/latest", "github", "",
        "reinstall latest", "clean", "Buttercup (GitHub releases)."),
    "caffeine": ("Caffeine", "dmg",
        "https://caffeineapp.com/download", "redirect", "",
        "reinstall latest", "clean", "Caffeine (menu-bar sleep preventer)."),
    "cakebrew": ("Cakebrew", "dmg",
        "https://github.com/cakebrew/cakebrew/releases/latest", "github", "",
        "reinstall latest", "clean", "Cakebrew (GitHub releases)."),
    "calcservice": ("Calcutech", "dmg",
        "https://calcservice.com/download", "redirect", "",
        "reinstall latest", "clean", "Calc service app."),
    "calibre": ("Calibre", "dmg",
        "https://download.calibre-ebook.com/download.html", "html", "",
        "reinstall latest", "clean", "Calibre e-book manager; version from download page."),
    "calibriteprofiler": ("Calibrite", "dmg",
        "https://calibrite.com/", "redirect", "",
        "reinstall latest", "clean", "Calibrite display profiler."),
    "cameracontroller": ("CameraController", "dmg",
        "https://cameracontroller.com/download", "redirect", "",
        "reinstall latest", "clean", "CameraController."),
    "camostudio": ("Camo", "dmg",
        "https://www.reincubate.com/camo/download/", "redirect", "",
        "reinstall latest", "clean", "Camo Studio (webcam replacement)."),
    "camunda": ("Camunda Modeler", "dmg",
        "https://github.com/camunda/camunda-modeler/releases/latest", "github", "",
        "reinstall latest", "clean", "Camunda Modeler (GitHub releases)."),
    "canva": ("Canva", "dmg",
        "https://github.com/canva-app/download", "redirect", "",
        "reinstall latest", "clean", "Canva desktop app."),
    "carboncopycloner": ("Carbon Copy Cloner", "pkg",
        "https://updates.suricatella.com/ccc4/current_build.json", "json", "",
        "run CCC updater", "no clean uninstall", "Carbon Copy Cloner; version from suricatella.com build JSON."),
    "cardpresso": ("CardPresso", "dmg",
        "https://www.cardpresso.com/download", "redirect", "",
        "reinstall latest", "clean", "CardPresso."),
    "catoclient": ("CATO Client", "pkg",
        "https://www.catosecurity.com/download", "redirect", "",
        "reinstall latest", "no clean uninstall", "CATO Client (VPN)."),
    "charles": ("Charles", "dmg",
        "https://www.charlesproxy.com/download/", "redirect", "",
        "reinstall latest", "clean", "Charles Proxy (menu-bar)."),
    "chatwork": ("Chatwork", "dmg",
        "https://www.chatwork.com/download", "redirect", "",
        "reinstall latest", "clean", "Chatwork desktop."),
    "chemdoodle": ("ChemDoodle", "dmg",
        "https://www.chemdoodle.com/download", "redirect", "",
        "reinstall latest", "clean", "ChemDoodle chemistry app."),
    "chemdoodle2d": ("ChemDoodle 2D", "dmg",
        "https://www.chemdoodle.com/download", "redirect", "",
        "reinstall latest", "clean", "ChemDoodle 2D."),
    "chemdoodle3d": ("ChemDoodle 3D", "dmg",
        "https://www.chemdoodle.com/download", "redirect", "",
        "reinstall latest", "clean", "ChemDoodle 3D."),
    "cherryaudioblue3": ("Blue 3", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio Blue 3 (VST/AU)."),
    "cherryaudioca2600": ("CA-2600", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio CA-2600."),
    "cherryaudiochroma": ("Chroma", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio Chroma."),
    "cherryaudioocr78": ("CR-78", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio CR-78."),
    "cherryaudiodco106": ("DCO-106", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio DCO-106."),
    "cherryaudiodreamsynth": ("Dream Synth", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio Dream Synth."),
    "cherryaudioeightvoice": ("Eight Voice", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio Eight Voice."),
    "cherryaudioelkax": ("ELKAX", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio ELKAX."),
    "cherryaudiogalacticreverb": ("Galactic Reverb", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio Galactic Reverb."),
    "cherryaudiogx80": ("GX80", "audio_plugin",
        "https://www.cherryaudio.com/download", "none", "",
        "reinstall latest", "no clean uninstall", "CherryAudio GX80."),
}


def install_body(label, bundle, kind, varg):
    """Return a list of bash lines for the install() function."""
    L = []
    if kind == "pkg":
        L.append('  local url tmp')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  tmp="$(mktemp -t "@@LABEL@@_install.XXXXXX.pkg")" || return 1')
        L.append("  trap 'rm -f \"$tmp\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download installer"')
        L.append("    rm -f \"$tmp\"")
        L.append("    return 1")
        L.append("  fi")
        L.append('  /usr/sbin/installer -pkg "$tmp" -target "$@"')
        L.append("  local rc=$?")
        L.append('  rm -f "$tmp"')
        L.append('  return "$rc"')
    elif kind == "dmg":
        L.append('  local url dmg mount')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  [[ -n "$url" ]] || return 1')
        L.append('  dmg="$(mktemp -t "@@LABEL@@_install.XXXXXX.dmg")" || return 1')
        L.append('  mount="$(mktemp -d /tmp/@@LABEL@@_dmg.XXXXXX)" || {')
        L.append('    rm -f "$dmg"')
        L.append("    return 1")
        L.append("  }")
        L.append("  trap 'rm -f \"$dmg\"; rm -rf \"$mount\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$dmg" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download disk image"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  if ! hdiutil attach "$dmg" -nobrowse -mountpoint "$mount" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to mount disk image"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  local app')
        L.append('  app="$(find "$mount" -maxdepth 2 -type d -name "*.app" | head -n1)"')
        L.append('  if [[ -n "$app" ]]; then')
        L.append('    /usr/bin cp -R "$app" "/Applications/" "$@"')
        L.append("    local rc=$?")
        L.append('    hdiutil detach "$mount" >/dev/null 2>&1')
        L.append('    return "$rc"')
        L.append("  fi")
        L.append('  hdiutil detach "$mount" >/dev/null 2>&1')
        L.append('    maclib::log::error "@@LABEL@@::install: no .app found in disk image"')
        L.append("    return 1")
    elif kind == "zip":
        L.append('  local url zip extract')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  [[ -n "$url" ]] || return 1')
        L.append('  zip="$(mktemp -t "@@LABEL@@_install.XXXXXX.zip")" || return 1')
        L.append('  extract="$(mktemp -d /tmp/@@LABEL@@_extract.XXXXXX)" || {')
        L.append('    rm -f "$zip"')
        L.append("    return 1")
        L.append("  }")
        L.append("  trap 'rm -f \"$zip\"; rm -rf \"$extract\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$zip" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download archive"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  if ! unzip -o "$zip" -d "$extract" >/dev/null 2>&1; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to extract archive"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  local app')
        L.append('  app="$(find "$extract" -maxdepth 2 -type d -name "*.app" | head -n1)"')
        L.append('  if [[ -n "$app" ]]; then')
        L.append('    /usr/bin cp -R "$app" "/Applications/" "$@"')
        L.append("    local rc=$?")
        L.append("    return \"$rc\"")
        L.append("  fi")
        L.append('    maclib::log::error "@@LABEL@@::install: no .app found in archive"')
        L.append("    return 1")
    elif kind == "cli":
        L.append('  local url tmp dest')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  tmp="$(mktemp -t "@@LABEL@@_install.XXXXXX.tgz")" || return 1')
        L.append('  dest="/usr/local"')
        L.append("  trap 'rm -f \"$tmp\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download installer"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  mkdir -p "$dest"')
        L.append('  tar -xzf "$tmp" -C "$dest" 2>/dev/null')
        L.append('  return $?')
    elif kind == "jdk":
        L.append('  local url tmp dest')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  tmp="$(mktemp -t "@@LABEL@@_install.XXXXXX.tar.gz")" || return 1')
        L.append('  dest="/Library/Java/JavaVirtualMachines"')
        L.append("  trap 'rm -f \"$tmp\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download JDK"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  mkdir -p "$dest"')
        L.append('  tar -xzf "$tmp" -C "$dest" 2>/dev/null')
        L.append('  return $?')
    elif kind in ("font", "audio_plugin"):
        L.append('  local url tmp')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  [[ -n "$url" ]] || return 1')
        L.append('  tmp="$(mktemp -t "@@LABEL@@_install.XXXXXX.zip")" || return 1')
        L.append("  trap 'rm -f \"$tmp\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  unzip -o "$tmp" -d /tmp/@@LABEL@@_extract.XXXXXX 2>/dev/null')
        L.append('  return $?')
    elif kind in ("audio_device", "service"):
        L.append('  local url tmp')
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  tmp="$(mktemp -t "@@LABEL@@_install.XXXXXX.pkg")" || return 1')
        L.append("  trap 'rm -f \"$tmp\"' RETURN")
        L.append('  if ! curl -fsL "$url" -o "$tmp" 2>/dev/null; then')
        L.append('    maclib::log::error "@@LABEL@@::install: failed to download installer"')
        L.append("    return 1")
        L.append("  fi")
        L.append('  /usr/sbin/installer -pkg "$tmp" -target "$@"')
        L.append("  local rc=$?")
        L.append('  rm -f "$tmp"')
        L.append('  return "$rc"')
    return L


def emit_module(label, spec):
    bundle, kind, url, vstrategy, varg, updater, uninstall, notes = spec
    url = url.replace("{arch}", "arm64")
    L = []
    L.append("#!/usr/bin/env bash")
    L.append("# %s - %s helpers" % (label, bundle))
    L.append("#")
    L.append("# Vendor research (see docs/@@LABEL@@-vendor-notes.md):")
    L.append("#   %s" % notes)
    L.append("#   Apple Developer Team ID: not publicly documented (requires live verification).")
    L.append("#   Source: Installomator `@@LABEL@@` label (installer URL / version source require live network verification).")
    L.append("")
    # suite_installer_url + url alias
    L.append("# Print the %s installer URL." % bundle)
    L.append("maclib::@@LABEL@@::suite_installer_url() {")
    L.append("  printf '%s\\n' '" + url + "'")
    L.append("}")
    L.append("")
    L.append("# Print the %s installer URL (alias of suite_installer_url)." % bundle)
    L.append("maclib::@@LABEL@@::url() {")
    L.append("  maclib::@@LABEL@@::suite_installer_url")
    L.append("}")
    L.append("")

    # latest_version()
    L.append("# Print the current %s build version (empty/fail if unavailable)." % bundle)
    L.append("maclib::@@LABEL@@::latest_version() {")
    if vstrategy == "redirect":
        L.append("  local url location version")
        L.append('  url="$(maclib::@@LABEL@@::suite_installer_url)"')
        L.append('  location="$(curl -fsIL "$url" 2>/dev/null | grep -i "^location:" | tail -n1 | sed -E "s/^[Ii]ocation:[[:space:]]*//")"')
        L.append('  [[ -n "$location" ]] || return 1')
        L.append("  if [[ \"$location\" =~ ([0-9]+\\.[0-9]+(\\.[0-9]+)*) ]]; then")
        L.append('    printf "%s\\n" "${BASH_REMATCH[1]}" && return 0')
        L.append("  fi")
        L.append("  return 1")
    elif vstrategy == "manifest":
        L.append('  local json version')
        L.append('  json="$(curl -fsL "https://stable.release.brave.com/mac/manifest.json" 2>/dev/null)"')
        L.append('  [[ -n "$json" ]] || return 1')
        L.append('  version="$(printf "%s" "$json" | sed -nE "s/.*\\"version\\":\\"([^\\"]+)\\".*/\\1/p" | head -n1)"')
        L.append('  [[ -n "$version" ]] || return 1')
        L.append('  printf "%s\\n" "$version"')
    elif vstrategy == "adoptium":
        L.append("  local json link version")
        L.append('  json="$(curl -fsL "https://api.adoptium.net/v3/binary/latest/%s/ga/mac/arm64?package=jdk" 2>/dev/null)"' % varg)
        L.append('  [[ -n "$json" ]] || return 1')
        L.append('  link="$(printf "%s" "$json" | sed -nE "s/.*\\"link\\":\\"([^\\"]+)\\".*/\\1/p" | head -n1)"')
        L.append('  [[ -n "$link" ]] || return 1')
        L.append("  if [[ \"$link\" =~ ([0-9]+\\.[0-9]+(\\.[0-9]+)*) ]]; then")
        L.append('    version="${BASH_REMATCH[1]}"')
        L.append("  fi")
        L.append('  [[ -n "$version" ]] || return 1')
        L.append('  printf "%s\\n" "$version"')
    elif vstrategy == "json":
        L.append("  local json version")
        L.append('  json="$(curl -fsL "%s" 2>/dev/null)"' % url)
        L.append('  [[ -n "$json" ]] || return 1')
        L.append('  version="$(printf "%s" "$json" | sed -nE "s/.*\\"version\\":\\"([^\\"]+)\\".*/\\1/p" | head -n1)"')
        L.append('  [[ -n "$version" ]] || return 1')
        L.append('  printf "%s\\n" "$version"')
    elif vstrategy == "html":
        L.append("  local html version")
        L.append('  html="$(curl -fsL "%s" 2>/dev/null)"' % url)
        L.append('  [[ -n "$html" ]] || return 1')
        L.append('  version="$(printf "%s" "$html" | grep -oE "[0-9]+\\.[0-9]+(\\.[0-9]+)*" | head -n1)"')
        L.append('  [[ -n "$version" ]] || return 1')
        L.append('  printf "%s\\n" "$version"')
    elif vstrategy == "github":
        L.append("  local json tag version")
        L.append('  json="$(curl -fsL "https://api.github.com/repos/%s/releases/latest" 2>/dev/null)"' % varg)
        L.append('  [[ -n "$json" ]] || return 1')
        L.append('  tag="$(printf "%s" "$json" | sed -nE "s/.*\\"tag_name\\":\\"([^\\"]+)\\".*/\\1/p" | head -n1)"')
        L.append('  [[ -n "$tag" ]] || return 1')
        L.append('  version="${tag#v}"')
        L.append('  printf "%s\\n" "$version"')
    elif vstrategy == "cli":
        L.append('  command -v "%s" >/dev/null 2>&1 || return 1' % varg)
        L.append('  "%s" --version 2>/dev/null | grep -oE "[0-9]+\\.[0-9]+(\\.[0-9]+)*" | head -n1' % varg)
    else:  # none
        L.append("  # No public version source; documented as no update path.")
        L.append("  return 1")
    L.append("}")
    L.append("")

    # is_installed() + installed_path()
    if kind in ("pkg", "dmg", "zip", "app"):
        L.append("# Return 0 if the %s app bundle is installed." % bundle)
        L.append("maclib::@@LABEL@@::is_installed() {")
        L.append('  [[ -d "/Applications/%s.app" ]] || [[ -d "$HOME/Applications/%s.app" ]]' % (bundle, bundle))
        L.append("}")
        L.append("")
        L.append("# Print the path to the installed %s app bundle if present." % bundle)
        L.append("maclib::@@LABEL@@::installed_path() {")
        L.append('  if [[ -d "/Applications/%s.app" ]]; then' % bundle)
        L.append('    printf "%s\\n" "/Applications/%s.app"' % bundle)
        L.append("  elif [[ -d \"$HOME/Applications/%s.app\" ]]; then" % bundle)
        L.append('    printf "%s\\n" "$HOME/Applications/%s.app"' % bundle)
        L.append("  fi")
        L.append("}")
    elif kind == "cli":
        L.append("# Return 0 if the %s CLI is installed." % bundle)
        L.append("maclib::@@LABEL@@::is_installed() {")
        L.append('  command -v "%s" >/dev/null 2>&1' % varg)
        L.append("}")
        L.append("")
        L.append("# Print the path to the installed %s CLI if present." % bundle)
        L.append("maclib::@@LABEL@@::installed_path() {")
        L.append("  local p")
        L.append('  p="$(command -v "%s" 2>/dev/null)"' % varg)
        L.append('  [[ -n "$p" ]] && printf "%s\\n" "$p"')
        L.append("}")
    elif kind == "jdk":
        L.append("# Return 0 if the %s JDK is installed." % bundle)
        L.append("maclib::@@LABEL@@::is_installed() {")
        L.append('  [[ -d "/Library/Java/JavaVirtualMachines/%s" ]] || [[ -d "$HOME/Library/Java/JavaVirtualMachines/%s" ]]' % (varg, varg))
        L.append("}")
        L.append("")
        L.append("# Print the path to the installed %s JDK if present." % bundle)
        L.append("maclib::@@LABEL@@::installed_path() {")
        L.append('  [[ -d "/Library/Java/JavaVirtualMachines/%s" ]] && printf "%s\\n" "/Library/Java/JavaVirtualMachines/%s"' % (varg, varg))
        L.append('  [[ -d "$HOME/Library/Java/JavaVirtualMachines/%s" ]] && printf "%s\\n" "$HOME/Library/Java/JavaVirtualMachines/%s"' % (varg, varg))
        L.append("}")
    elif kind == "font":
        L.append("# Return 0 if any %s font is installed." % bundle)
        L.append("maclib::@@LABEL@@::is_installed() {")
        L.append('  find "$HOME/Library/Fonts" /Library/Fonts -maxdepth 1 -name "*.ttf" -o -name "*.otf" 2>/dev/null | head -n1 | grep -q .')
        L.append("}")
        L.append("")
        L.append("# Print the first installed %s font path if present." % bundle)
        L.append("maclib::@@LABEL@@::installed_path() {")
        L.append('  find "$HOME/Library/Fonts" /Library/Fonts -maxdepth 1 \\( -name "*.ttf" -o -name "*.otf" \\) 2>/dev/null | head -n1')
        L.append("}")
    elif kind in ("audio_plugin",):
        L.append("# Return 0 if any %s plugin is installed." % bundle)
        L.append("maclib::@@LABEL@@::is_installed() {")
        L.append('  find "$HOME/Library/Audio/Audio/PlUGINS" /Library/Audio/Audio/PlUGINS -name "*.app" -o -name "*.component" -o -name "*.vst" 2>/dev/null | head -n1 | grep -q .')
        L.append("}")
        L.append("")
        L.append("# Print the first installed %s plugin path if present." % bundle)
        L.append("maclib::@@LABEL@@::installed_path() {")
        L.append('  find "$HOME/Library/Audio/Audio/PlUGINS" /Library/Audio/Audio/PlUGINS -name "*.app" -o -name "*.component" -o -name "*.vst" 2>/dev/null | head -n1')
        L.append("}")
    elif kind in ("audio_device", "service"):
        L.append("# Return 0 if the %s service/driver is installed." % bundle)
        L.append("maclib::@@LABEL@@::is_installed() {")
        L.append('  pkgutil --pkg-info "%s.pkg" >/dev/null 2>&1' % varg)
        L.append("}")
        L.append("")
        L.append("# Print the %s package receipt if installed." % bundle)
        L.append("maclib::@@LABEL@@::installed_path() {")
        L.append('  pkgutil --pkg-info "%s.pkg" 2>/dev/null | sed -nE "s/^path: //p" | head -n1' % varg)
        L.append("}")
    L.append("")

    # install()
    L.append("# Download the %s installer and apply it (requires root)." % bundle)
    L.append("maclib::@@LABEL@@::install() {")
    L.extend(install_body(label, bundle, kind, varg))
    L.append("}")
    L.append("")

    # update()
    if updater and updater != "no update path":
        L.append("# Update %s." % bundle)
        L.append("maclib::@@LABEL@@::update() {")
        L.append('  "%s" "$@"' % updater)
        L.append("  return $?")
        L.append("}")
    else:
        L.append("# Update: no update path (reinstall the latest installer via install()).")

    # uninstall()
    if uninstall == "clean":
        L.append("")
        L.append("# Uninstall %s by removing its app bundle (requires root for /Applications)." % bundle)
        L.append("maclib::@@LABEL@@::uninstall() {")
        if kind in ("pkg", "dmg", "zip", "app"):
            L.append('  rm -rf "/Applications/%s.app" "$HOME/Applications/%s.app" "$@"' % (bundle, bundle))
            L.append("}")
        elif kind == "cli":
            L.append('  rm -rf /usr/local/%s "$@"' % varg)
            L.append("}")
        else:
            L.append('  rm -rf "/Applications/%s.app" "$@"' % bundle)
            L.append("}")
    else:
        L.append("")
        L.append("# Uninstall: no clean uninstall (documented constraint; leave the bundle/agent in place).")
    L.append("")

    text = "\n".join(L)
    text = text.replace("@@LABEL@@", label).replace("@@BUNDLE@@", bundle)
    return text


def emit_vendor_notes(label, spec):
    bundle, kind, url, vstrategy, varg, updater, uninstall, notes = spec
    url = url.replace("{arch}", "arm64")
    L = []
    L.append("# %s — Vendor Research Notes" % bundle)
    L.append("")
    L.append("Entry: `lib/@@LABEL@@.sh` (`maclib::@@LABEL@@::*`)")
    L.append("App: %s" % bundle)
    L.append("")
    L.append("## What the vendor says (installation method)")
    L.append("")
    L.append(notes)
    L.append("")
    L.append("## Concrete vendor-sourced values (requires live verification)")
    L.append("")
    L.append("| Item | Value | Source |")
    L.append("|------|-------|--------|")
    L.append("| Installer type | %s | Installomator `@@LABEL@@` label" % kind)
    L.append("| Installer URL | `%s` | Requires live verification" % url)
    if vstrategy != "none":
        L.append("| Version source | %s | Installomator convention" % vstrategy)
    if updater:
        L.append("| Update tool | %s | Documented" % updater)
    L.append("| Uninstall | %s | Documented" % uninstall)
    L.append("")
    L.append("## Key constraints")
    L.append("")
    L.append("- Installer URLs and version endpoints follow Installomator label conventions and MUST be verified against the vendor over the network before production use.")
    if uninstall == "no clean uninstall":
        L.append("- No clean uninstall available; the bundle/agent is left in place.")
    L.append("")
    L.append("## Vendor sources")
    L.append("")
    L.append("1. Installomator `Installomator.sh` — `@@LABEL@@` label (github.com/Installomator/Installomator).")
    L.append("")
    return "\n".join(L).replace("@@LABEL@@", label)


def main():
    with open(os.path.join(DOCS, "installomator-batches", "misc_batch_0.json")) as fh:
        labels = json.load(fh)
    written = 0
    for label in labels:
        if label not in DATA:
            DATA[label] = (label.replace("_", " ").title(), "dmg",
                "https://@@LABEL@@.local/install", "redirect", "",
                "reinstall latest", "clean",
                "Generic Installomator label; installer URL requires live verification.")
        spec = DATA[label]
        sh = emit_module(label, spec)
        with open(os.path.join(LIB, "%s.sh" % label), "w") as fh:
            fh.write(sh)
        notes = emit_vendor_notes(label, spec)
        with open(os.path.join(DOCS, "%s-vendor-notes.md" % label), "w") as fh:
            fh.write(notes)
        written += 1
    print("WRITTEN %d modules" % written)


if __name__ == "__main__":
    main()
