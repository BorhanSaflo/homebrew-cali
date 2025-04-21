class Cali < Formula
  desc "A terminal calculator with real-time evaluation, unit conversions, and natural language expressions."
  homepage "https://github.com/BorhanSaflo/cali#readme"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.6.0/cali-aarch64-apple-darwin.tar.xz"
      sha256 "e111c3e07264e28468e96535606560a628a909983b41489fd0a44b5745a22bf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.6.0/cali-x86_64-apple-darwin.tar.xz"
      sha256 "648134d288b639942e437c6fdd07303665ec7558724485520ebe8e88dba930ec"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BorhanSaflo/cali/releases/download/v0.6.0/cali-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d16074e843041ef9a0ccccbb389a91d1c8b44e97379577ac9c5e54dd7360aeb6"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cali" if OS.mac? && Hardware::CPU.arm?
    bin.install "cali" if OS.mac? && Hardware::CPU.intel?
    bin.install "cali" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
