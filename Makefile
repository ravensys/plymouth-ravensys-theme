prefix = /usr
datarootdir = $(prefix)/share
datadir = $(datarootdir)

srcdir = src

THEMENAME = ravensys
THEMEDESC = RavenSys charging logo Plymouth theme.
VERSION = $(shell date '+%Y%m%d')

LOGOWIDTH = 512
LOGOHEIGHT = 160
LOGOALPHA = 70

PROGRESSLEN = 16

THROBBERLEN = 16

source-files += logo.svgz
source-files += theme.plymouth.in
source-files += $(addprefix resource/,$(static-resources))

obj-dir = obj

progress-filename = progress
progress-sequence = $(shell seq -w 0 $$(( $(PROGRESSLEN) - 1 )))
progress-animation = $(addprefix $(progress-filename)-,$(addsuffix .png,$(progress-sequence)))

throbber-filename = throbber
throbber-sequence = $(shell seq -w 0 $$(( $(THROBBERLEN) - 1 )))
throbber-animation = $(addprefix $(throbber-filename)-,$(addsuffix .png,$(throbber-sequence)))

static-resources = background-tile.png box.png bullet.png entry.png lock.png

dist-filename = plymouth-theme-$(THEMENAME)
dist-files += $(addprefix $(srcdir)/, $(source-files))
dist-files += Makefile
dist-files += LICENSE
dist-files += README.md

release-filename = plymouth-theme-$(THEMENAME)-$(VERSION)
release-files += $(progress-animation)
release-files += $(throbber-animation)
release-files += $(static-resources)
release-files += $(THEMENAME).plymouth
release-files += LICENSE

install-dir = $(datadir)/plymouth/themes/$(THEMENAME)

VPATH = $(srcdir)

.PHONY: all
all: $(progress-animation) $(throbber-animation) $(static-resources) $(THEMENAME).plymouth

.PHONY: install
install:
	install -d -m 0755 $(DESTDIR)$(install-dir)
	install -m 0644 $(progress-animation) $(DESTDIR)$(install-dir)
	install -m 0644 $(throbber-animation) $(DESTDIR)$(install-dir)
	install -m 0644 $(static-resources) $(DESTDIR)$(install-dir)
	install -m 0644 $(THEMENAME).plymouth $(DESTDIR)$(install-dir)

.PHONY: uninstall
uninstall:
	rm -f $(addprefix $(DESTDIR)$(install-dir)/,$(progress-animation))
	rm -f $(addprefix $(DESTDIR)$(install-dir)/,$(throbber-animation))
	rm -f $(addprefix $(DESTDIR)$(install-dir)/,$(static-resources))
	rm -f $(DESTDIR)$(install-dir)/$(THEMENAME).plymouth
	rm -rf $(DESTDIR)$(install-dir)

.PHONY: clean
clean:
	rm -rf $(obj-dir)
	rm -f $(progress-animation)
	rm -f $(throbber-animation)
	rm -f $(static-resources)
	rm -f $(THEMENAME).plymouth

.PHONY: cleanall
cleanall: clean
	rm -f $(dist-filename).tar.gz $(dist-filename).tar.xz
	rm -f $(release-filename).tar.gz $(release-filename).tar.xz

.PHONY: dist
dist: $(dist-filename).tar.gz $(dist-filename).tar.xz

.PHONY: release
release: $(release-filename).tar.gz $(release-filename).tar.xz

$(THEMENAME).plymouth: theme.plymouth.in
	sed \
		-e "s/@THEMENAME@/$(THEMENAME)/" \
		-e "s/@THEMEDESC@/$(THEMEDESC)/" \
		"$<" > "$@"

$(progress-animation): $(progress-filename)-%.png: $(obj-dir)/logo-transparent.png $(obj-dir)/logo.png
	convert "$<" \
		\( "$(obj-dir)/logo.png" -gravity south -crop "0x$$(( ((10#$* * $(LOGOHEIGHT)) / ($(PROGRESSLEN) - 1)) + 1 ))+0+0" \) \
		-gravity south -composite png32:"$@"

$(throbber-animation): $(throbber-filename)-%.png: $(obj-dir)/logo-extent.png
	convert "$<" \
		\( "$<" -blur "0x$$( if [ $* -lt $$(( $(THROBBERLEN) / 2 )) ]; then echo $$(( 10#$* * 5 )); else echo $$(( ($(THROBBERLEN) - 10#$* - 1) * 5 )); fi )" \) \
		-composite png32:"$@"

$(static-resources): %: resource/%
	cp "$<" "$@"

$(obj-dir):
	mkdir -p "$@"

$(obj-dir)/logo.png: logo.svgz | $(obj-dir)
	inkscape -z -e "$@" -w "$(LOGOWIDTH)" -h "$(LOGOHEIGHT)" "$<"

$(obj-dir)/logo-extent.png: $(obj-dir)/logo.png
	convert "$<" -background none -gravity center -extent "$$(echo '$(LOGOWIDTH) * 1.4 / 1' | bc)x$$(echo '$(LOGOHEIGHT) * 1.4 / 1' | bc)" png32:"$@"

$(obj-dir)/logo-transparent.png: $(obj-dir)/logo.png
	convert "$<" -alpha on -channel a -evaluate subtract "$(LOGOALPHA)%" png32:"$@"

$(dist-filename).tar.gz:
	tar -czf "$@" --transform "s/^\./$(dist-filename)/" $(addprefix ./,$(dist-files))

$(dist-filename).tar.xz:
	tar -cJf "$@" --transform "s/^\./$(dist-filename)/" $(addprefix ./,$(dist-files))

$(release-filename).tar.gz: all
	tar -czf "$@" --transform "s/^\./$(release-filename)/" $(addprefix ./,$(release-files))

$(release-filename).tar.xz: all
	tar -cJf "$@" --transform "s/^\./$(release-filename)/" $(addprefix ./,$(release-files))

