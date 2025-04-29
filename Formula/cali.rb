class Cali < Formula
  desc "A terminal calculator with real-time evaluation, unit conversions, and natural language expressions."
  homepage "https://github.com/BorhanSaflo/cali#readme"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.9.0/cali-aarch64-apple-darwin.tar.xz"
      sha256 "2e83d1da7b7aa3656646dd47e23369c727cfe5c9d6c41a4218aa9c12bb469275"
    end
    if Hardware::CPU.intel?
      url "https://github.com/BorhanSaflo/cali/releases/download/v0.9.0/cali-x86_64-apple-darwin.tar.xz"
      sha256 "98dc56b81311041d005c03dd01202ccdd2c53a43e07fd0d2afd26ea25b401e7b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/BorhanSaflo/cali/releases/download/v0.9.0/cali-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c3a695c7d77cc4f681c116458b64a7ffb6c825b7ef8e6f450d04e121a7090217"
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
