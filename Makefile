BUILDDIR = build
INSTALLDIR = /usr/share/plymouth/themes/ravensys
RESOURCEDIR = resource
SOURCEDIR = src

DISTNAME = plymouth-theme-ravensys
DISTFILE = $(DISTNAME)-$(shell date '+%Y%m%d')

PROGRESSFILE = progress
THROBBERFILE = throbber

LOGO_NAME = ravensys-white
LOGO_WIDTH = 500
LOGO_HEIGHT = 160
LOGO_TRANSPARENCY = 70

THROBBER_WIDTH = $(shell echo "$(LOGO_WIDTH) * 1.4 / 1" | bc)
THROBBER_HEIGHT = $(shell echo "$(LOGO_HEIGHT) * 1.4 / 1" | bc)

PROGRESSSTEP = $(shell echo "$(LOGO_HEIGHT) / 16" | bc)

.PHONY: build
build:
	@echo "Preparing build environment ..."
	@mkdir -p $(BUILDDIR)
	@mkdir -p $(BUILDDIR)/resource
	
	@echo "Compiling resources ..."
	@inkscape -z \
		-e "$(BUILDDIR)/resource/$(LOGO_NAME).png" \
		-w $(LOGO_WIDTH) \
		-h $(LOGO_HEIGHT) \
		"$(SOURCEDIR)/$(LOGO_NAME).svgz"
	
	@echo "Generating resources ..."
	@convert \
		"$(BUILDDIR)/resource/$(LOGO_NAME).png" \
		-alpha on -channel a -evaluate subtract $(LOGO_TRANSPARENCY)% \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-transparent.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME).png" \
		-crop $(LOGO_WIDTH)x$(PROGRESSSTEP) -reverse \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-%02d.png"
	
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME).png" \
		-background none -gravity center -extent $(THROBBER_WIDTH)x$(THROBBER_HEIGHT) \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" \
		-gaussian-blur 5x5 \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-5.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" \
		-gaussian-blur 10x10 \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-10.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" \
		-gaussian-blur 15x15 \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-15.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" \
		-gaussian-blur 20x20 \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-20.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" \
		-gaussian-blur 25x25 \
		"$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-25.png"
	
	@echo "Generating progress animation files ..."
	@cp "$(BUILDDIR)/resource/$(LOGO_NAME)-transparent.png" "$(BUILDDIR)/$(PROGRESSFILE)-00.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-00.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-00.png" -geometry +0+$$(echo "$(PROGRESSSTEP) * 15" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-01.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-01.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-01.png" -geometry +0+$$(echo "$(PROGRESSSTEP) * 14" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-02.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-02.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-02.png" -geometry +0+$$(echo "$(PROGRESSSTEP) * 13" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-03.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-03.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-03.png" -geometry +0+$$(echo "$(PROGRESSSTEP) * 12" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-04.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-04.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-04.png" -geometry +0+$$(echo "$(PROGRESSSTEP) * 11" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-05.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-05.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-05.png" -geometry +0+$$(echo "$(PROGRESSSTEP) * 10" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-06.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-06.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-06.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  9" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-07.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-07.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-07.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  8" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-08.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-08.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-08.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  7" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-09.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-09.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-09.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  6" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-10.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-10.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-10.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  5" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-11.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-11.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-11.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  4" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-12.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-12.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-12.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  3" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-13.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-13.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-13.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  2" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-14.png"
	@convert "$(BUILDDIR)/$(PROGRESSFILE)-14.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-splitpart-14.png" -geometry +0+$$(echo "$(PROGRESSSTEP) *  1" | bc) -composite "$(BUILDDIR)/$(PROGRESSFILE)-15.png"
	
	@echo "Generating throbber animation files ..."
	@cp "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" "$(BUILDDIR)/$(THROBBERFILE)-00.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-5.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" -composite "$(BUILDDIR)/$(THROBBERFILE)-01.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-10.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" -composite "$(BUILDDIR)/$(THROBBERFILE)-02.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-15.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" -composite "$(BUILDDIR)/$(THROBBERFILE)-03.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-20.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" -composite "$(BUILDDIR)/$(THROBBERFILE)-04.png"
	@convert "$(BUILDDIR)/resource/$(LOGO_NAME)-extent-blur-25.png" "$(BUILDDIR)/resource/$(LOGO_NAME)-extent.png" -composite "$(BUILDDIR)/$(THROBBERFILE)-05.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-05.png" "$(BUILDDIR)/$(THROBBERFILE)-06.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-05.png" "$(BUILDDIR)/$(THROBBERFILE)-07.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-05.png" "$(BUILDDIR)/$(THROBBERFILE)-08.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-05.png" "$(BUILDDIR)/$(THROBBERFILE)-09.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-05.png" "$(BUILDDIR)/$(THROBBERFILE)-10.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-04.png" "$(BUILDDIR)/$(THROBBERFILE)-11.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-03.png" "$(BUILDDIR)/$(THROBBERFILE)-12.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-02.png" "$(BUILDDIR)/$(THROBBERFILE)-13.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-01.png" "$(BUILDDIR)/$(THROBBERFILE)-14.png"
	@cp "$(BUILDDIR)/$(THROBBERFILE)-00.png" "$(BUILDDIR)/$(THROBBERFILE)-15.png"
	
	@echo "Copying resources ..."
	@cp "$(RESOURCEDIR)/background-tile.png" "$(BUILDDIR)/background-tile.png"
	@cp "$(RESOURCEDIR)/box.png" "$(BUILDDIR)/box.png"
	@cp "$(RESOURCEDIR)/bullet.png" "$(BUILDDIR)/bullet.png"
	@cp "$(RESOURCEDIR)/entry.png" "$(BUILDDIR)/entry.png"
	@cp "$(RESOURCEDIR)/lock.png" "$(BUILDDIR)/lock.png"
	
	@echo "Copying theme definition ..."
	@cp "$(SOURCEDIR)/ravensys.plymouth" "$(BUILDDIR)/ravensys.plymouth"
	
	@echo "Copying LICENSE ..."
	@cp "LICENSE" "$(BUILDDIR)/LICENSE"
	
	@echo "Removing temporary resource files ..."
	@rm -r "$(BUILDDIR)/resource"
	
	@echo "Done!"

.PHONY: dist
dist: build
	@echo "Generating distribution archive ..."
	@tar -czf "$(DISTFILE).tar.gz" --transform "s/build/$(DISTFILE)/" "$(BUILDDIR)"
	@tar -cJf "$(DISTFILE).tar.xz" --transform "s/build/$(DISTFILE)/" "$(BUILDDIR)"
	@echo "Done!"

.PHONY: install
install: build
	@echo "Installing theme ..."
	@mkdir -p $(INSTALLDIR)
	@cp $(BUILDDIR)/* $(INSTALLDIR)/
	@echo "Done!"

.PHONY: uninstall
uninstall:
	@echo "Uninstalling theme ..."
	@rm -r $(INSTALLDIR)
	@echo "Done!"

.PHONY: clean
clean:
	@echo "Cleaning up after build ..."
	@rm -rf $(BUILDDIR)
	@echo "Done!"

.PHONY: distclean
distclean:
	@echo "Cleaning up distribution archive(s) ..."
	@rm -f $(DISTFILE)-*.tar.gz $(DISTFILE)-*.tar.xz
	@echo "Done!"
	
.PHONY: cleanall
cleanall: clean distclean

