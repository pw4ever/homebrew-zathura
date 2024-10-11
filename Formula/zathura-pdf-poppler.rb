class ZathuraPdfPoppler < Formula
  desc "Poppler backend plugin for zathura"
  homepage "https://pwmt.org/projects/zathura-pdf-poppler/"
  url "https://github.com/pwmt/zathura-pdf-poppler/archive/0.3.0.tar.gz"
  sha256 "2034f70a936d458ddc9276f769e77ff308ba3bb1b7a7cdc87bab8b9ef7ade84a"
  head "https://github.com/pwmt/zathura-pdf-poppler.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "poppler"
  depends_on "zathura"

  def install
    inreplace "meson.build", "zathura.get_variable(pkgconfig: 'plugindir')", "'#{prefix}'"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    <<-EOS
      To enable this plugin you will need to link it in place.
      First create the plugin directory if it does not exist yet:
        $ mkdir -p $(brew --prefix zathura)/lib/zathura
      Then link the .dylib to the directory:
        $ ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib

      More information as to why this is needed: https://github.com/zegervdv/homebrew-zathura/issues/19
    EOS
  end

  test do
    system "true" # TODO
  end
end
