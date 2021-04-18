#! /bin/bash
 
# Change to the home dir and setup the required vars
BIG_DATA_DIR=$HOME/BigData
 
JAVA_HOME=$BIG_DATA_DIR/jdk1.8.0_281
MAVEN_HOME=$BIG_DATA_DIR/apache-maven-3.8.1
HADOOP_HOME=$BIG_DATA_DIR/hadoop-2.10.1
INTELLIJ_HOME=$BIG_DATA_DIR/idea-IC-211.6693.111
 
# Download the required dependencies
download_dependencies() {
	mkdir $BIG_DATA_DIR
	cd $BIG_DATA_DIR
 
	echo "Downloading Hadoop..."
	wget "https://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz"	
 
	echo "Downloading Maven..."
	wget "https://apache.osuosl.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz"
 
	echo "Downloading IntelliJ IDEA..."
	wget "https://download.jetbrains.com/idea/ideaIC-2021.1.tar.gz"
  
  	cd $HOME
}
 
# Move a given file to the bigdata directory
move_to_big_data_dir() {
	cp $1 $BIG_DATA_DIR
}
 
# Extract the given .tar.gz files
extract_archives() {
	JDK_ARCHIVE_PATH=$1
 
	cd $BIG_DATA_DIR
	echo "Extracting JDK..."
	tar -xzf `basename $JDK_ARCHIVE_PATH`
	echo "Extracted JDK."
 
	echo "Extracting Maven..."
	tar -xzf $MAVEN_HOME-bin.tar.gz 
	echo "Extracted Maven."
 
	echo "Extracting Hadoop..."
	tar -xzf $HADOOP_HOME.tar.gz
	echo "Extracted Hadoop."
 
	echo "Extracting IntelliJ IDEA..."
	tar -xzf $BIG_DATA_DIR/ideaIC-2021.1.tar.gz
	echo "Extracted IntelliJ IDEA."
}
 
# Set up the ~/.bash_profile
setup_paths() {
	touch ~/.bash_profile
	echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bash_profile
	echo "export MAVEN_HOME=$MAVEN_HOME" >> ~/.bash_profile
	echo "export HADOOP_HOME=$HADOOP_HOME" >> ~/.bash_profile
 
	echo "export PATH=\$PATH:$JAVA_HOME/bin" >> ~/.bash_profile
	echo "export PATH=\$PATH:$MAVEN_HOME/bin" >> ~/.bash_profile
	echo "export PATH=\$PATH:$HADOOP_HOME/bin" >> ~/.bash_profile
	echo "export PATH=\$PATH:$INTELLIJ_HOME/bin" >> ~/.bash_profile
 
	source ~/.bash_profile 
}
 
# Run the final setup
setup() {
	# Get and check the full path of the JDK tar.gz archive
	JDK_ARCHIVE_PATH=`pwd`/$1
	if [ -z $JDK_ARCHIVE_PATH ]; then
		echo "Usage: setup.sh <JDK Path>"
		echo "Please input a valid JDK path."
		exit 1
	fi
 
	echo "Downloading required dependencies..."
	download_dependencies
 
	echo "Moving everything to the right place..." 
	move_to_big_data_dir $JDK_ARCHIVE_PATH
 
	echo "Extracting archives... could take a few minutes"
	extract_archives $JDK_ARCHIVE_PATH
 
	echo "Setting up paths"
	setup_paths
 
	echo "Done."
}
 
# Handle the command line args
case $1 in
help)
	echo "Usage: setup.sh <JDK Path>"
	;;
clean)
	rm -rf $JAVA_HOME
	rm -rf $MAVEN_HOME
	rm -rf $HADOOP_HOME
	rm -rf $INTELLIJ_HOME
	;;
*)
	setup $1   # Pass the JDK archive path to setup()
esac
