class Cali < Formula
  desc "A terminal calculator with real-time evaluation, unit conversions, and natural language expressions."
  homepage "https://github.com/BorhanSaflo/cali#readme"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.8.0/cali-aarch64-apple-darwin.tar.xz"
      sha256 "ec3a6eae43d8564821db2b3de4c6ab5a354745761794236c2d976a1cf2823cdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.8.0/cali-x86_64-apple-darwin.tar.xz"
      sha256 "bc0c60eba085a353c9943d1fef2c74a67a2542b5fa510bd761343654a50e8f9a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BorhanSaflo/cali/releases/download/v0.8.0/cali-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "545f487bc798faa31ea1a708c13204f5368b0f0eb61c5400ee8fa3768ad17489"
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
