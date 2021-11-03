#!/usr/bin/env bash

# NOTE:
# This doesn't work as is on Windows. You'll need to create an equivalent `.bat` file instead
#
# NOTE:
# If you're not using Linux you'll need to adjust the `-configuration` option
# to point to the `config_mac' or `config_win` folders depending on your system.

echo $JAVA_HOME

JAR="$XDG_DATA_HOME/lang-servers/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar"

GRADLE_HOME=$HOME/.gradle $JAVA_HOME/bin/java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1g \
  -Xmx2G \
  -jar $(echo "$JAR") \
  -configuration "$XDG_DATA_HOME/lang-servers/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_mac" \
  -data "${1:-$XDG_DATA_HOME/lang-servers/eclipse/jdtls-workspace}" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED

# nela Note: The script is symlinked from /usr/local/bin

# The script must be placed in a folder that is part of $PATH. To verify that the installation worked, launch it in a shell. You should get the following output:

# Content-Length: 126
#
# {"jsonrpc":"2.0","method":"window/logMessage","params":{"type":3,"message":"Sep 16, 2020, 8:10:53 PM Main thread is waiting"}}

