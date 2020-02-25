require_relative "github_download_strategy.rb" 
# This file is generated by the release script, do not change it directly.
class YakAT0Beta < Formula
  desc "A command line tool to manage dev environments on Kubernetes"
  homepage "https://github.com/eventbrite/yak"
  url "https://api.github.com/repos/eb-rubenespinosa/go-tests/releases/assets/18275369", :using => CustomGitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "cf98323560840e5f2ee7f7170015a811f5293bc1f463aab01eafff64f89499ca"
  version "1.1.45-beta"
  bottle :unneeded
  depends_on "kubernetes-cli"
  depends_on "watch"
  
  keg_only :versioned_formula 
  
  resource "aws-iam-authenticator" do
    url "https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/darwin/amd64/aws-iam-authenticator"
    sha256 "ef60d7ea5108b4de19f7fe59514643a7665df6832f94be620405138d8f60dd18"
  end
  
  resource "vault-aws-iam-authenticator" do
    url "https://jenkins.evbhome.com/job/vault-aws-iam-authenticator-release/lastSuccessfulBuild/artifact/src/github.com/eventbrite/vault-aws-iam-authenticator/vault-aws-iam-authenticator-darwin-amd64-0.0.6.tar.gz"
    sha256 "1ed235cbab1fea887dba7ad9383005030d8a6250b61072cb1c343a147715f33f"
  end
  
  def install
    bin.install "yak"
    resource("aws-iam-authenticator").stage { bin.install "aws-iam-authenticator" }
    resource("vault-aws-iam-authenticator").stage { bin.install "vault-aws-iam-authenticator" }
  end
end
