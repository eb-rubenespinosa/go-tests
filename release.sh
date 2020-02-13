#!/bin/sh
# release a new version of yak
set -e
set -x

if [ -z "${VERSION}" ]; then
    echo "Error: Invalid version: $VERSION"
    exit 1
fi
if [ -z "${CHANGELOG}" ]; then
    echo "Error: Invalid changelog: $CHANGELOG"
    exit 1
fi

if grep -w "$VERSION" CHANGELOG.md; then
    echo "Error: $VERSION already released, found a changelog entry for it."
    exit 1
fi

# download the MacOS release from Github
# get the release asset URL
release_url=$ASSET_URL

RELEASE_BRANCH="master"

git clone git@github.com:$REPOSITORY.git 

# Generate brew config file
cat <<EOF >yak.rb
# This file is generated by the release script, do not change it directly.
class Yak < Formula
  desc "A command line tool to manage dev environments on Kubernetes"
  homepage "https://github.com/eventbrite/yak"
  url "$release_url"
  sha256 "$SHA_256"
  version "$VERSION"
  bottle :unneeded
  depends_on "kubernetes-cli"
  depends_on "watch"

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
EOF

# update change log file
DATE=`date +%Y-%m-%d`
cat >>CHANGELOG.md <<EOL

## $VERSION ($DATE)
$CHANGELOG
EOL

# update README file
sed -i -e 's/linux-amd64-.*\.tar\.gz /linux-amd64-'"$VERSION"'.tar.gz /g' README.md

git add yak.rb CHANGELOG.md README.md

git commit -m "Release $VERSION"

echo "Pushing version $VERSION to $RELEASE_BRANCH branch"
git push origin $RELEASE_BRANCH -f
