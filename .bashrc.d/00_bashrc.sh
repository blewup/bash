# Fedora Chroot Helper Function
start_chroot() {
    # Check root
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This command must be run as root" >&2
        return 1
    fi

    local PINK='\033[1;95m'
    local RESET='\033[0m'

    echo -e "\n${PINK}STARTING THE CHROOT PROCEDURES${RESET}"
    echo -e "          ${PINK}IN 10 SECONDS${RESET}"

    # 10-second countdown with 25-char pink bar
    for ((i=10; i>=1; i--)); do
        local bar=""
        local filled=$(( (11 - i) * 25 / 10 ))
        for ((j=0; j<filled; j++)); do bar+="#"; done
        for ((j=filled; j<25; j++)); do bar+=" "; done
        echo -ne "\r[${PINK}$bar${RESET}]"
        echo -ne "   ${PINK}$i seconds remaining${RESET}"
        sleep 1
    done

    echo -e "\r${PINK}[#########################]${RESET}\n"
    echo -e "  ${PINK}Starting to mount the directories${RESET}"

    local TARGET="${1:-/mnt/fedora}"
    local EFI_PART="/dev/nvme0n1p2"
    local BOOT_PART="/dev/nvme0n1p5"
    local ROOT_PART="/dev/nvme0n1p6"
    local HOME_PART="/dev/sda1"

    echo "=== Starting chroot setup for $TARGET ==="

    # Create target if needed
    mkdir -p "$TARGET" || return 1

    # Mount partitions
    mount "$ROOT_PART" "$TARGET" || return 1
    mkdir -p "$TARGET/boot" && mount "$BOOT_PART" "$TARGET/boot" || return 1
    mkdir -p "$TARGET/boot/efi" && mount "$EFI_PART" "$TARGET/boot/efi" || return 1
    echo "[OK] Mounted root, boot, and EFI partitions"

    # Mount /home
    mkdir -p "$TARGET/home" && mount "$HOME_PART" "$TARGET/home" || return 1
    echo "[OK] Mounted home partition"

    # Mount system directories
    mkdir -p "$TARGET/proc" && mount -t proc /proc "$TARGET/proc" && mount --make-rslave "$TARGET/proc"
    mkdir -p "$TARGET/sys" && mount -t sysfs /sys "$TARGET/sys" && mount --make-rslave "$TARGET/sys"
    mkdir -p "$TARGET/dev" && mount --rbind /dev "$TARGET/dev" && mount --make-rslave "$TARGET/dev"
    mkdir -p "$TARGET/run" && mount --bind /run "$TARGET/run" && mount --make-rslave "$TARGET/run"
    mkdir -p "$TARGET/tmp" && chmod 1777 /tmp && mount -t tmpfs tmpfs "$TARGET/tmp"
    mkdir -p "$TARGET/dev/pts" && mount -t devpts /dev/pts "$TARGET/dev/pts" && mount --make-rslave "$TARGET/dev/pts"

    echo "[OK] All 6 system directories mounted successfully"

    # Create tmp files needed to install pkgs
    mkdir -p "${TARGET}/tmp/user/0" && chmod 700 "${TARGET}/tmp/user/0"


    # Simple backup line for grub2-install
    mkdir -p "$TARGET/sys/firmware/efi/efivars" && mount /dev/nvme0n1p2 "$TARGET/boot/efi" && mount -t efivarfs efivarfs "$TARGET/sys/firmware/efi/efivars"


    echo -e "\nEntering chroot in 5 seconds..."
    for i in {5..1}; do
        # Calculate progress bar length (25 chars total)
        local bar=""
        local filled=$(( (6-i) * 5 ))  # 25/5 = 5 chars per second
        for ((j=0; j<filled; j++)); do bar+="#"; done
        for ((j=filled; j<25; j++)); do bar+=" "; done

        echo -ne "\r[${PINK}$bar]${RESET}"
        echo -ne "${PINK}$i seconds remaining.${RESET}"
        sleep 1
    done
    echo -e "\r[###  STARTING  CHROOT  ###]"

    chroot "$TARGET" /bin/bash --login
}

# Ending chroot env
end_chroot() {
    local CHROOT_TARGET="/mnt/fedora"

    # Detect if inside chroot
    if [[ "$(df / | tail -1 | awk '{print $6}')" == "/" && "$(stat -c %m /)" != "/" ]]; then
        echo "You appear to still be inside the chroot at $CHROOT_TARGET."
        echo "Please exit the chroot before running this script."
        return 1
    fi

    echo "Preparing to unmount chroot at $CHROOT_TARGET..."
    echo -e "Starting unmount in 10 seconds...\n"

    local PINK='\033[1;95m'
    local RESET='\033[0m'

    echo -e "\n${PINK}LEAVING CHROOT IN 10 SECONDS${RESET}"

    # 10-second countdown with 25-char pink bar
    for ((i=10; i>=1; i--)); do
        local bar=""
        local filled=$(( (11 - i) * 25 / 10 ))
        for ((j=0; j<filled; j++)); do bar+="#"; done
        for ((j=filled; j<25; j++)); do bar+=" "; done
        echo -ne "\r${PINK}[$bar]${RESET}"
        echo -ne "   ${PINK}$i seconds remaining${RESET}"
        sleep 1
    done

    echo -e "\r${PINK}[#########################]${RESET}\n"
    echo -e "  ${PINK}Starting umount the directories${RESET}"

    # Unmount order
    local -a RELATIVE_MOUNTS=(
        "/dev/pts"
        "/dev"
        "/run"
        "/tmp/user/0"
        "/tmp"
        "/sys/firmware/efi/efivars"
        "/sys"
        "/proc"
        "/boot/efi"
        "/boot"
        "/home"
        ""
    )

    for rel in "${RELATIVE_MOUNTS[@]}"; do
        local mount_path="${CHROOT_TARGET}${rel}"
        if mountpoint -q "$mount_path"; then
            echo "Attempting to unmount: $mount_path"
            if umount -lf "$mount_path" 2>/dev/null; then
                echo "✅ Unmounted $mount_path"
            else
                echo "🟥 Failed to unmount $mount_path"
            fi
        else
            echo "⚠️ $mount_path is not mounted"
        fi
    done

    unset CHROOT_TARGET
    echo -e "\nAll possible unmount operations attempted."
}

# Proper completion function
chroot_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    mapfile -t COMPREPLY < <(compgen -d -- "$cur")
}

complete -F chroot_completion start_chroot

