;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
;; Import nonfree linux module.
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))
(use-modules (gnu packages curl)  ;; curl
             (gnu packages wget)  ;; wget
             (gnu packages gnome)
             (gnu packages gnome-xyz)
             (gnu packages version-control)  ;; git
             (gnu packages compression)  ;; unzip
             (gnu packages linux)
             (gnu packages file-systems)
             (gnu packages xorg)
             (gnu packages libreoffice)  ;; libreoffice
             (gnu packages video)  ;; vlc
             (gnu packages gstreamer)  ;; gst-plugins-*
             (gnu packages xdisorg)
             (gnu packages ncurses)  ;; ncurses
             (gnu packages ebook)  ;; calibre
             (gnu packages fonts)
             (gnu packages ghostscript)
             (gnu packages fontutils)
             (gnu packages gl)  ;; mesa, mesa-utils
             (gnu packages package-management)  ;; flatpak
             (gnu packages ssh)  ;; openssh
             (gnu packages admin)  ;; inxi
             (gnu services pm)  ;; tlp, thermald
             (gnu services cups))  ;; cups; printing

(use-service-modules desktop networking ssh xorg)

;; define my services; substiution servers etc.
(define %my-services
  (modify-services %desktop-services
    (elogind-service-type config =>
      (elogind-configuration (inherit config)
      (handle-lid-switch-external-power 'suspend)))
    (guix-service-type config =>
      (guix-configuration
        (inherit config)
        (substitute-urls (append
                           %default-substitute-urls
                           (list "https://mirror.brielmaier.net")))
        (authorized-keys (append
                           %default-authorized-guix-keys
                           (list (local-file "mirror.brielmaier.net.pub"))))))))

;; define libinput config
(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"

  Option \"Tapping\" \"on\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"on\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
EndSection
Section \"InputClass\"
  Identifier \"Keyboards\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsKeyboard \"on\"
EndSection
")

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware amdgpu-firmware))
  (locale "en_US.utf8")
  (timezone "Africa/Accra")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "jumpship")
  (users (cons* (user-account
                  (name "hil")
                  (comment "Hilary")
                  (group "users")
                  (home-directory "/home/hil")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "lp")))
                %base-user-accounts))

  (packages
    (append
      (list (specification->package "nss-certs")
            tree
            openssh
            inxi
            mesa
            mesa-utils
            gs-fonts
            font-hack
            font-gnu-freefont
            font-liberation
            font-terminus
            font-dejavu
            font-anonymous-pro
            freetype
            font-awesome
            font-adobe-source-code-pro
            font-google-roboto
            fontconfig
            bluez
            tlp
            xclip
            ncurses
            gst-libav
            gst-plugins-base
            gst-plugins-good
            gst-plugins-bad
            gst-plugins-ugly
            curl
            wget
            gvfs
            ntfs-3g
            exfat-utils
            fuse-exfat
            xf86-input-libinput
            arc-icon-theme
            papirus-icon-theme
            arc-theme
            git
            unzip
            flatpak
            gnome-shell-extension-dash-to-dock
            libreoffice
            vlc
            gnome-tweaks
            evince
            calibre
      )
      %base-packages))

  (services
    (append
      (list (service gnome-desktop-service-type)
            (bluetooth-service #:auto-enable? #t)
            (service cups-service-type)
            (service tlp-service-type
              (tlp-configuration
                (tlp-default-mode "BAT")))
            (service thermald-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout)
                (extra-config (list %xorg-libinput-config)))))
      %my-services))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "0962a5ad-1470-4e46-bce1-60cfc8596dd7")))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "8656-CDA7" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "0b0a22e8-0e2e-46a9-889e-a4beea8b87e7"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
