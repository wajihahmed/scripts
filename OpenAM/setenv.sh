JAVA_OPTS="-server -d64 -Xms1024m -Xmx1024m -XX:MaxPermSize=128m -XX:+UseParNewGC -XX:MaxNewSize=256m -XX:NewSize=256m -XX:MaxTenuringThreshold=1 -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Xloggc:/tmp/amgc.log -XX:+PrintTenuringDistribution"
#JPDA_OPTS="-agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n"
