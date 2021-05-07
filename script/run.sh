HOME_DIR=$1

PROJECT_DIR="$HOME_DIR/projects"
RESOURCE_DIR="$PROJECT_DIR/$PROJECT_NAME"
IMAGE_FILE="$RESOURCE_DIR/image.png"
PROPERTY_SCRIPT="$RESOURCE_DIR/property.sh"

DATABASE_DIR="$HOME_DIR/database"
JPN_POPULATION_DATA_FILE="$DATABASE_DIR/JPN_population.csv"
JPN_POSITION_DATA_FILE="$DATABASE_DIR/JPN_longitude_latitude.csv"

DATA_DIR="$HOME_DIR/data/$PROJECT_NAME"
HEIGHT_DATA_FILE="$DATA_DIR/height_data.txt"
HEIGHT_DATA_DIGIT="5"
CITY_DATA_FILE="$DATA_DIR/city_list.txt"
PATH_DATA_FILE="$DATA_DIR/path_list.txt"
URBAN_DATA_FILE="$DATA_DIR/urban_data.txt"
URBAN_AREA_DATA_FILE="$DATA_DIR/urban_area_data.txt"

SCRIPT_DIR="$HOME_DIR/script"
PARAMETER_SCRIPT="$SCRIPT_DIR/parameter.sh"

mkdir -p $DATA_DIR

. $PROPERTY_SCRIPT

UPDATE_COMMON_ARG () {
    
    COMMON_ARG="$HEIGHT_DATA_FILE $IMAGE_WIDTH \
    $IMAGE_HEIGHT $HEIGHT_DATA_DIGIT $CITY_DATA_FILE \
    $LONGITUDE_START $LONGITUDE_END $LATITUDE_START $LATITUDE_END \
    $PATH_DATA_FILE $URBAN_DATA_FILE $URBAN_AREA_DATA_FILE \
    $HEIGHT_SCORE $HEIGHT_DIFFELENCE_SCORE $DISTANCE_SCORE \
    $URBAN_AREA_SCORE $SEA_AREA_SCORE $POPULATION_SCORE \
    $KRUSKAL_PATH_MIN_POPULATRION $KRUSKAL_PATH_MAX_ANGLE_DIFFELENCE \
    $KRUSKAL_PATH_MAX_CROSS $PATH_RELEASE_INTERVAL $PATH_DRAFT_INTERVAL \
    $URBAN_AREA_HEIGHT_DIFFELENCE_SCORE $URBAN_WIDE_AREA_DENSITY $URBAN_CENTRAL_AREA_DENSITY \
    $MAX_PATH_DISTANCE_PER_CITY_DISTANCE $MAX_BRIDGE_DISTANCE \
    $MAX_CITY_DISTANCE $PROJECT_NAME \
    $PATH_COLOR_R $PATH_COLOR_G $PATH_COLOR_B $PATH_WIDTH \
    $MARK_COLOR_R $MARK_COLOR_G $MARK_COLOR_B $MARK_WIDTH"
}
. $PARAMETER_SCRIPT
UPDATE_COMMON_ARG

if [ $PNG_2_HEIGHT_DATA = "1" ]; then
    (cd $HOME_DIR/png2heightdata;. png2heightdata.sh $IMAGE_FILE $HEIGHT_DATA_FILE \
    $HEIGHT_DIFFELENCE $IMAGE_WIDTH $IMAGE_HEIGHT $HEIGHT_DATA_DIGIT)
fi

if [ $CITY_DATABASE_2_DATA = "1" ]; then
    (cd $HOME_DIR/citydatabase2data;. citydatabase2data.sh $JPN_POPULATION_DATA_FILE \
    $JPN_POSITION_DATA_FILE $CITY_DATA_FILE \
    $LONGITUDE_START $LONGITUDE_END $LATITUDE_START $LATITUDE_END)
fi

if [ $URBAN_DATA = "1" ]; then
    echo "" > $URBAN_DATA_FILE
    echo "" > $URBAN_AREA_DATA_FILE
    (cd $HOME_DIR/urbandata;. urbandata.sh $COMMON_ARG)
fi

if [ $SIM_PATH = "1" ]; then
    echo "" > $PATH_DATA_FILE
    for (( c=0; ; c++ ))
    do  
        PATH_SCRIPT="$RESOURCE_DIR/path/path_${c}.sh"
        if [ -f $PATH_SCRIPT ]; then
            . $PARAMETER_SCRIPT
            . $PATH_SCRIPT
            UPDATE_COMMON_ARG
            (cd $HOME_DIR/simpath;. simpath.sh $COMMON_ARG)
        else
            break
        fi
    done
fi

if [ $DATA_OUTPUT = "1" ]; then
    (cd $HOME_DIR/data_output;. data_output.sh $COMMON_ARG)
fi