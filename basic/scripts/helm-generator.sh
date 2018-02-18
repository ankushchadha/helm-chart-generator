#!/bin/sh

print_help() {
    echo "Usage:"
    echo "  helm-generator.sh --limit=2 --repo=stable --rt-url= --username= --password= --rt-repo-path="
    echo ""
    echo "  * limit : Max # of versions created per chart (default value=1)"
    echo "  * repo : Helm repository (default value: stable)"
    echo "  * rt-url: Artifactory url"
    echo "  * username: Artifactory username"
    echo "  * password: Artifactory access token or apikey"
    echo "  * rt-repo-path: Artifactory helm repository's relative path"
}

generate_charts() {
    # chart version app
    # echo Fetching $1
    helm fetch $1 --untar
    mkdir target temp && cp -R $3 temp/
    cd target
    uversion=$2

    for (( k=1; k <= $limit; ++k ))
    do
        uversion=$(echo $uversion | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
        sed -i -e "s|$2|$uversion|g" ../temp/$3/Chart.yaml
        helm package ../temp/$3
        cp -f ../$3/Chart.yaml ../temp/$3/
    done
}


init_dir() {
    rm -fr $1 || true
    mkdir -p $1 && cd $1
}

delete(){
    echo "Cleanup"
    rm -rf $HOME_DIR/$repo
}


main() {
    helm repo update
    #helm search | while read one two three; do echo $one $two; done | grep $repo >list
    tail -n +2 list | while read -r key value; do setup_generate_charts $key $value; done
}


setup_generate_charts() {
    HOME_DIR=$(pwd)
    IFS='/'
    read -ra str <<< "$1"
    IFS=' '
    repo=${str[0]}
    app=${str[1]}
    version=$2
    chart=$repo/$app

    echo $chart $repo $app $version

    init_dir $chart
    generate_charts $chart $version $app
    jfrog rt u --threads=$threads --props=$PROPS  "*.tgz" $repoPath/
    cd $HOME_DIR
}

repo=stable
limit=1
threads=7
PROPS="autogen=true"

for i in "$@"
	do
	case $i in
	    -l=* | --limit=* )
	    shift
	    limit="${i#*=}"
	;;
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
            echo $repoPath
	;;
	    -h | --help )
	    print_help
	    exit 1;
   esac
done

echo ""
echo "$0 : repo=$repo limit=$limit"
echo ""

jfrog rt c --url=$rtURL --user=$rtUser --password=$rtPasswd --interactive=false


main
