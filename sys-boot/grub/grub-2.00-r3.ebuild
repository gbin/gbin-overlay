# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/grub/grub-2.00-r2.ebuild,v 1.6 2013/03/31 17:04:36 floppym Exp $

EAPI=4

if [[ ${PV} == "9999" ]] ; then
	EBZR_REPO_URI="http://bzr.savannah.gnu.org/r/grub/trunk/grub/"
	LIVE_ECLASS="bzr"
	SRC_URI=""
	DO_AUTORECONF="true"
else
	MY_P=${P/_/\~}
	if [[ ${PV} == *_alpha* || ${PV} == *_beta* || ${PV} == *_rc* ]]; then
		SRC_URI="mirror://gnu-alpha/${PN}/${MY_P}.tar.xz"
	else
		SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.xz
		mirror://gentoo/${MY_P}.tar.xz"
	fi
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}
	DO_AUTORECONF="true"
fi

inherit eutils flag-o-matic multiprocessing pax-utils toolchain-funcs ${DO_AUTORECONF:+autotools} ${LIVE_ECLASS}
unset LIVE_ECLASS

DESCRIPTION="GNU GRUB boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"

LICENSE="GPL-3"
SLOT="2"
IUSE="custom-cflags debug device-mapper doc efiemu mount nls static sdl truetype libzfs"

GRUB_PLATFORMS=(
	# everywhere:
	emu
	# mips only:
	qemu-mips yeeloong
	# amd64, x86, ppc, ppc64:
	ieee1275
	# amd64, x86:
	coreboot multiboot efi-32 pc qemu
	# amd64, ia64:
	efi-64
)
IUSE+=" ${GRUB_PLATFORMS[@]/#/grub_platforms_}"

REQUIRED_USE="grub_platforms_qemu? ( truetype )
	grub_platforms_yeeloong? ( truetype )"

# os-prober: Used on runtime to detect other OSes
# xorriso (dev-libs/libisoburn): Used on runtime for mkrescue
RDEPEND="
	app-arch/xz-utils
	>=sys-libs/ncurses-5.2-r5
	debug? (
		sdl? ( media-libs/libsdl )
	)
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	libzfs? ( sys-fs/zfs )
	mount? ( sys-fs/fuse )
	truetype? (
		media-libs/freetype
		media-fonts/dejavu
		>=media-fonts/unifont-5
	)
	ppc? ( sys-apps/ibm-powerpc-utils sys-apps/powerpc-utils )
	ppc64? ( sys-apps/ibm-powerpc-utils sys-apps/powerpc-utils )
"
DEPEND="${RDEPEND}
	>=dev-lang/python-2.5.2
	sys-devel/flex
	sys-devel/bison
	sys-apps/help2man
	sys-apps/texinfo
	static? (
		truetype? (
			app-arch/bzip2[static-libs(+)]
			media-libs/freetype[static-libs(+)]
			sys-libs/zlib[static-libs(+)]
		)
	)
"
RDEPEND+="
	kernel_linux? (
		grub_platforms_efi-32? ( sys-boot/efibootmgr )
		grub_platforms_efi-64? ( sys-boot/efibootmgr )
	)
"
if [[ -n ${DO_AUTORECONF} ]] ; then
	DEPEND+=" >=sys-devel/autogen-5.10"
fi
if [[ ${PV} != 9999 ]]; then
	DEPEND+=" app-arch/xz-utils"
fi

export STRIP_MASK="*/grub/*/*.{mod,img}"

QA_EXECSTACK="
	usr/bin/grub*
	usr/sbin/grub*
	usr/lib*/grub/*/*.mod
	usr/lib*/grub/*/kernel.exec
	usr/lib*/grub/*/kernel.img
	usr/lib*/grub/*/setjmp.module
"

QA_WX_LOAD="
	usr/lib*/grub/*/kernel.exec
	usr/lib*/grub/*/kernel.img
	usr/lib*/grub/*/*.image
"

QA_PRESTRIPPED="
	usr/lib.*/grub/.*/kernel.img
"

grub_run_phase() {
	local phase=$1
	local platform=$2
	[[ -z ${phase} || -z ${platform} ]] && die "${FUNCNAME} [phase] [platform]"

	[[ -d "${WORKDIR}/build-${platform}" ]] || \
		{ mkdir "${WORKDIR}/build-${platform}" || die ; }
	pushd "${WORKDIR}/build-${platform}" > /dev/null || die

	echo ">>> Running ${phase} for platform \"${platform}\""
	echo ">>> Working in: \"${WORKDIR}/build-${platform}\""

	grub_${phase} ${platform}

	popd > /dev/null || die
}

grub_src_configure() {
	local platform=$1
	local with_platform=
	local enable_efiemu="--disable-efiemu"

	[[ -z ${platform} ]] && die "${FUNCNAME} [platform]"

	# Used below for efi cross-building
	tc-export CC NM OBJCOPY STRIP

	estack_push CTARGET "${CTARGET}"
	estack_push TARGET_CC "${TARGET_CC}"
	estack_push TARGET_CFLAGS "${TARGET_CFLAGS}"
	estack_push TARGET_CPPFLAGS "${TARGET_CPPFLAGS}"

	case ${platform} in
		efi-32)
			if [[ ${CHOST} == x86_64* ]]; then
				CTARGET="${CTARGET:-i386}"
				TARGET_CC="${TARGET_CC:-${CC}}"
				export TARGET_CC
			fi
			with_platform="--with-platform=efi"
			;;
		efi-64)
			if [[ ${CHOST} == i?86* ]]; then
				CTARGET="${CTARGET:-x86_64}"
				TARGET_CC="${TARGET_CC:-${CC}}"
				TARGET_CFLAGS="-Os -march=x86-64 ${TARGET_CFLAGS}"
				TARGET_CPPFLAGS="-march=x86-64 ${TARGET_CPPFLAGS}"
				export TARGET_CC TARGET_CFLAGS TARGET_CPPFLAGS
			fi
			with_platform="--with-platform=efi"
			;;
		guessed) ;;
		*)
			with_platform="--with-platform=${platform}"
			case ${CTARGET:-${CHOST}} in
				i?86*|x86_64*)
					enable_efiemu=$(use_enable efiemu)
					;;
			esac
			;;
	esac

	ECONF_SOURCE="${S}" \
	econf \
		--libdir=/usr/lib \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--disable-werror \
		--program-prefix= \
		--program-transform-name="s,grub,grub2," \
		--with-grubdir=grub2 \
		${with_platform} \
		$(use_enable debug mm-debug) \
		$(use_enable debug grub-emu-usb) \
		$(use_enable device-mapper) \
		${enable_efiemu} \
		$(use_enable mount grub-mount) \
		$(use_enable nls) \
		$(use_enable truetype grub-mkfont) \
		$(use_enable libzfs) \
		$(use sdl && use_enable debug grub-emu-sdl)

	estack_pop CTARGET CTARGET || die
	estack_pop TARGET_CC TARGET_CC || die
	estack_pop TARGET_CFLAGS TARGET_CFLAGS || die
	estack_pop TARGET_CPPFLAGS TARGET_CPPFLAGS || die
}

grub_src_compile() {
	default_src_compile
	pax-mark -mpes "${grub_binaries[@]}"
}

grub_build_docs() {
	emake -C docs html
}

grub_src_install() {
	default_src_install
}

grub_install_docs() {
	emake -C docs DESTDIR="${D}" install-html
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# Bug 439082
		if $(tc-getLD) --version | grep -q "GNU gold"; then
			eerror "GRUB does not function correctly when built with the gold linker."
			eerror "Please select the bfd linker with binutils-config."
			die "GNU gold detected"
		fi
	fi
}

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		epatch "${FILESDIR}/${P}-parallel-make.patch" #424231
		epatch "${FILESDIR}/${P}-no-gets.patch" #424703
		epatch "${FILESDIR}/${P}-config-quoting.patch" #426364
		epatch "${FILESDIR}/${P}-tftp-endian.patch" # 438612
		epatch "${FILESDIR}/${P}-hardcoded-awk.patch" #424137
		epatch "${FILESDIR}/${P}-freebsd.patch" #442050
		epatch "${FILESDIR}/${P}-compression.patch" #424527
		epatch "${FILESDIR}/${P}-zfs-feature-flag-support.patch" #455358
		epatch "${FILESDIR}/${P}-20_linux_xen.patch" #463992
		epatch "${FILESDIR}/${P}-dmraid.patch"
	fi

	# fix texinfo file name, bug 416035
	sed -i \
		-e 's/^\* GRUB:/* GRUB2:/' \
		-e 's/(grub)/(grub2)/' -- \
		"${S}"/docs/grub.texi

	epatch_user

	# autogen.sh does more than just run autotools
	if [[ -n ${DO_AUTORECONF} ]] ; then
		sed -i -e '/^autoreconf/s:^:set +e; e:' autogen.sh || die
		(
			autopoint() { :; }
			. ./autogen.sh
		) || die
	fi

	# install into the right dir for eselect #372735
	sed -i \
		-e '/^bashcompletiondir =/s:=.*:= $(datarootdir)/bash-completion:' \
		util/bash-completion.d/Makefile.in || die

	# get enabled platforms
	GRUB_ENABLED_PLATFORMS=""
	local i
	for i in ${GRUB_PLATFORMS[@]}; do
		use grub_platforms_${i} && GRUB_ENABLED_PLATFORMS+=" ${i}"
	done
	[[ -z ${GRUB_ENABLED_PLATFORMS} ]] && GRUB_ENABLED_PLATFORMS="guessed"
	einfo "Going to build following platforms: ${GRUB_ENABLED_PLATFORMS}"
}

src_configure() {
	local i

	use custom-cflags || unset CCASFLAGS CFLAGS CPPFLAGS LDFLAGS
	use static && append-ldflags -static
	use elibc_FreeBSD && append-cppflags "-isystem /usr/include"

	# Sandbox bug 404013.
	use libzfs && addpredict /etc/dfs:/dev/zfs

	multijob_init
	for i in ${GRUB_ENABLED_PLATFORMS}; do
		multijob_child_init grub_run_phase ${FUNCNAME} ${i}
	done
	multijob_finish || die
}

src_compile() {
	# Used for pax marking in grub_src_compile
	local grub_binaries=(
		grub-editenv
		grub-fstest
		grub-menulst2cfg
		grub-mkimage
		grub-mklayout
		grub-mkpasswd-pbkdf2
		grub-mkrelpath
		grub-script-check
		grub-bios-setup
		grub-ofpathname
		grub-probe
		grub-sparc64-setup
	)
	use mount && grub_binaries+=( grub-mount )
	use truetype && grub_binaries+=( grub-mkfont )

	local i

	for i in ${GRUB_ENABLED_PLATFORMS}; do
		grub_run_phase ${FUNCNAME} ${i}
	done

	# Just build docs once
	use doc && grub_run_phase build_docs ${i}
}

src_install() {
	local i

	for i in ${GRUB_ENABLED_PLATFORMS}; do
		grub_run_phase ${FUNCNAME} ${i}
	done

	use doc && grub_run_phase install_docs ${i}

	mv "${ED}"usr/share/info/grub{,2}.info || die

	# can't be in docs array as we use default_src_install in different builddir
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	insinto /etc/default
	newins "${FILESDIR}"/grub.default-2 grub
}

pkg_preinst() {
	has_version "<sys-boot/grub-2.00-r2:2" && \
		[[ "$(df -TP /boot | awk 'NR>1{print $2}')" = 'zfs' ]]
	display_zfs_feature_flag_warning=$?
}

pkg_postinst() {
	# display the link to guide
	elog "For information on how to configure grub-2 please refer to the guide:"
	elog "    http://wiki.gentoo.org/wiki/GRUB2_Quick_Start"
	if ! has_version sys-boot/os-prober; then
		elog "Install sys-boot/os-prober to enable detection of other operating systems using grub2-mkconfig."
	fi
	if ! has_version dev-libs/libisoburn; then
		elog "Install dev-libs/libisoburn to enable creation of rescue media using grub2-mkrescue."
	fi
	if has_version sys-boot/grub:0; then
		ewarn "If you want to keep GRUB Legacy (grub-0.97) installed, please run"
		ewarn "the following to add sys-boot/grub:0 to your world file."
		ewarn "emerge --noreplace sys-boot/grub:0"
	fi
	if [[ $display_zfs_feature_flag_warning -eq 0 ]]; then
		zfs_pool=$(df -TP /boot | awk 'NR>1{print $1}')
		zfs_pool=${zfs_pool%%/*}
		ewarn "The previous version of sys-boot/grub lacked support for ZFS feature flags."
		ewarn "Your /boot is on ZFS. Running \"zpool upgrade ${zfs_pool}\" or \"zpool upgrade -a\""
		ewarn "to upgrade your pool to support feature flags will prevent your system from booting."
		ewarn "You should use grub2-install to reinstall your boot code. This will avoid problems."
	fi
}
