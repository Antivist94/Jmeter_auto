#!/bin/sh

#Author: Alexey Chichuk
#Description: main steps to start use these scripts

_PWD=$(pwd)
_TEST_FRAGMENTS_FOLDER="$_PWD/test-plan/test_fragments/"
_BIN_REPO="https://stash.bank24.int/scm/qa/jmeter-bin.git"
_JMETER_VERSION="5.4.3"
_JMETER_DOWNLOAD_URL="https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$_JMETER_VERSION.tgz"


echo "Binary update is needed"
if [ "$(ls -l | grep -c "apache-jmeter")" -ge 1 ]; then
  echo "\nRemoving folder apache-jmeter ...."
    rm -rf $_PWD/apache-jmeter/
fi

echo "\nClonning jmeter-bin repo ..."
git clone $_BIN_REPO $_PWD/jmeter-bin

echo "\nDownloading the binary from" + $_JMETER_DOWNLOAD_URL
curl -L --silent $_JMETER_DOWNLOAD_URL -k > jmeter-bin/jmeter/apache-jmeter-$_JMETER_VERSION.tgz

echo "\nUnzipping .tgz binary..."
eval tar zxvf $_PWD/jmeter-bin/jmeter/apache-jmeter-$_JMETER_VERSION.tgz
mv apache-jmeter-$_JMETER_VERSION apache-jmeter

echo "\nUpdate allure-reporter, installer.sh ..."
mv $_PWD/jmeter-bin/allure-reporter.groovy $_PWD/allure-reporter.groovy
mv $_PWD/jmeter-bin/installer.sh $_PWD/installer.sh && chmod +x $_PWD/installer.sh

echo "\nCopy libriries ..."
cp -a $_PWD/jmeter-bin/jmeter/lib/. $_PWD/apache-jmeter/lib
rm $_PWD/apache-jmeter/lib/tika-core-1.24.1.jar $_PWD/apache-jmeter/lib/tika-parsers-1.24.1.jar $_PWD/apache-jmeter/lib/json-path-2.4.0.jar

cp -rf $_PWD/jmeter-bin/jmeter/jmeter.properties $_PWD/apache-jmeter/bin

echo "\nUpdate includecontroller.prefix ..."
sed -i -e "s%#includecontroller.prefix=%includecontroller.prefix=$_TEST_FRAGMENTS_FOLDER%g" \
  $_PWD/apache-jmeter/bin/jmeter.properties

echo "\nRemove jmeter-bin(tmp) folder ..."
rm -rf $_PWD/jmeter-bin/


sleep 2
echo "\ndone!"
