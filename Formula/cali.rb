class Cali < Formula
  desc "A terminal calculator with real-time evaluation, unit conversions, and natural language expressions."
  homepage "https://github.com/BorhanSaflo/cali#readme"
  version "0.5.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.5.8/cali-aarch64-apple-darwin.tar.xz"
      sha256 "db3e1959602700652edb67dba2448ab1fa3fad95a2baa50ff7833700d3cd3c9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.5.8/cali-x86_64-apple-darwin.tar.xz"
      sha256 "aa8c878b602c4cca13e2b64bd0316466f060fbb96ba0aca53dc7575ab6502549"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BorhanSaflo/cali/releases/download/v0.5.8/cali-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8e57c6ac4cb530a44a3c92e36180ca068b575842413e8a4164f58f658c8741ed"
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
