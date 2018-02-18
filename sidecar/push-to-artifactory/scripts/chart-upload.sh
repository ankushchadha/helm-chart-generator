#!/bin/sh

print_help() {
    echo "Usage:"
    echo "  chart-upload.sh --threads=20 --rt-url= --username= --password= --rt-repo-path= --repo="
    echo ""
    echo "  * threads : # of threads used by jfrog cli to upload helm charts"
    echo "  * rt-url: Artifactory URL"
    echo "  * username: Artifactory username"
    echo "  * password: Artifactory password"
    echo "  * repo : helm repository. Default: stable"
    echo "  * rt-repo-path: Artifactory Helm Repository. Example helm-prod/"
    echo ""
}

main() {
    upload_charts
}

upload_charts() {
    jfrog rt u --threads=$threads --props=$PROPS  "$repo/*/target/*.tgz" $repoPath/
}

repo=stable
threads=7
PROPS="autogen=true"

for i in "$@"
	do
	case $i in
	    -r=* | --repo=* )
	    shift
	    repo="${i#*=}"
	;;
	    -rt=* | --rt-url=* )
	    shift
	    rtURL="${i#*=}"
	    echo $rt-url
	;;
	    -u=* | --username=* )
	    shift
	    rtUser="${i#*=}"
	;;
	    -p=* | --password=* )
	    shift
	    rtPasswd="${i#*=}"
	;;
	    -t=* | --threads=* )
	    shift
	    threads="${i#*=}"
	;;
	    -rp=* | --rt-repo-path=* )
	    shift
	    repoPath="${i#*=}"
	;;
	    -h | --help )
	    print_help
	    exit 1;
   esac
done

echo ""
echo "$0 : repo=$repo repoPath=$repoPath"
echo ""

jfrog rt c --url=$rtURL --user=$rtUser --password=$rtPasswd --interactive=false
main
