#!/bin/sh

print_help() {
    echo "Usage:"
    echo "  helm-generator.sh --limit=2 --repo=stable --createList=false"
    echo ""
    echo "  * limit : max # of versions created per chart (default value=1)"
    echo "  * repo : helm repository (default value: stable)"
    echo ""
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
# repo/chart/target folder will include all charts, if sidecar is not used, then cli can upload aritfacts from this location instead of a single location that has a lot of files.

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
    if [ "$createList" = "true" ];
    then
        helm search | while read one two three; do echo $one $two; done | grep $repo >list ;
        echo "Generated list of charts";
    fi
    # Generate versions of charts specified in the list. Ignoring the header incase the file is generated
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

    # Generate versions of a chart
    generate_charts $chart $version $app
    cd $HOME_DIR
}

# Default values
repo=stable
limit=1

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
	    -cl=* | --createList=* )
	    shift
	    createList="${i#*=}"
	    if [ "$createList" != "TRUE" ]
	     then
	        if [ "$createList" != "true" ]
	            then
	                createList=false;
	        fi
	     fi
	     echo $createList
	;;
	    -h | --help )
	    print_help
	    exit 1;
   esac
done

echo "$@"
echo ""
echo "$0 : repo=$repo limit=$limit createList=$createList"
echo ""

main
# TODO: Remove tail once the object is changed to Job from Deployment
tail -f /dev/null
