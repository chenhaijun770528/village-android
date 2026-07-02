#!/usr/bin/env sh

# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
app_path=$0

# Need this for daisy-chained symlinks.
while
    APP_HOME=${app_path%"/*"}  # leaves the leading
    [ "$APP_HOME" != "$app_path" ] && [ -L "$app_path" ]
do
    new_path=$(ls -ld "$app_path")
    new_path=${new_path#*-> }
    app_path=$new_path
done

# This is normally unused, but needed for some edge cases where APP_HOME is not derived from $0
APP_HOME=$(cd "${APP_HOME:-./}" && pwd -P) || exit

APP_NAME="Gradle"
APP_BASE_NAME=$(basename "$0")

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Use the maximum available, which is that of the JVM.
# Try to get the max heap size, or default to 512m if failed.
max_heap_size=$(java -XX:+PrintFlagsFinal -version 2>/dev/null | grep MaxHeapSize | awk '{print $4}' | awk '{$1=int($1/1024/1024); print $1"m";}')
if [ -z "$max_heap_size" ]; then
    max_heap_size="512m"
fi

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the Java command.
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME
Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
Please set the JAVA_HOME variable in your environment to match the
location of your Java installation, or install a JDK that's available from your PATH."
fi

# Increase the maximum file descriptors if we can.
if [ "$( uname )" = "Linux" ] || [ "$( uname )" = "Darwin" ] ; then
    MAX_FD_LIMIT=$( ulimit -H -n 2>/dev/null )
    if [ $? -eq 0 ] ; then
        # If MAX_FD_LIMIT is blank then we couldn't determine the limit, so don't try to change it.
        if [ -n "$MAX_FD_LIMIT" ] && [ "$MAX_FD_LIMIT" != "unlimited" ] ; then
            # If we can, raise the limit.
            ulimit -n "$MAX_FD_LIMIT" 2>/dev/null
        fi
    fi
fi

# Run the application
exec "$JAVACMD" $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS \
    -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" \
    org.gradle.wrapper.GradleWrapperMain "$@"
