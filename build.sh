# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir dist dist/xslt dist/helpers dist/config
fi
# Likewise, create the package dir
if [[ ! -d package ]]
	then mkdir package
fi

# Get the current version
VERSION=`grep -o ' packageVersion \"\(.*\)\"' version.ent | awk '{print $2}' | sed 's/"//g'`

# Make sure to use the PRODUCTION entities
UMBOFF="umbraco \"IGNORE\""
UMBON="umbraco \"INCLUDE\""

TMOFF="textmate \"IGNORE\""
TMON="textmate \"INCLUDE\""

sed -i "" "s/$UMBOFF/$UMBON/" */entities.ent
sed -i "" "s/$TMON/$TMOFF/" */entities.ent

sed -i "" "s/$UMBOFF/$UMBON/" lib/mocks/entities.ent
sed -i "" "s/$TMON/$TMOFF/" lib/mocks/entities.ent

# Transform the development XSLT into the release files
xsltproc --novalid --output package/_PaginationHelper.xslt lib/freezeEntities.xslt paginationhelper/_PaginationHelper.xslt
xsltproc --novalid --output package/_NavigationHelper.xslt lib/freezeEntities.xslt navigationhelper/_NavigationHelper.xslt
xsltproc --novalid --output package/_GroupingHelper.xslt lib/freezeEntities.xslt groupinghelper/_GroupingHelper.xslt
xsltproc --novalid --output package/_CalendarHelper.xslt lib/freezeEntities.xslt calendarhelper/_CalendarHelper.xslt
xsltproc --novalid --output package/_MediaHelper.xslt lib/freezeEntities.xslt mediahelpers/_MediaHelper.xslt
xsltproc --novalid --output package/_MultiPickerHelper.xslt lib/freezeEntities.xslt multipickerhelper/_MultiPickerHelper.xslt

# Fix transformed entity references in attributes
sed -i "" "s/\&amp;\([A-Za-z]*\);/\&\1;/" package/_NavigationHelper.xslt
sed -i "" "s/\&amp;\([A-Za-z]*\);/\&\1;/" package/_CalendarHelper.xslt
sed -i "" "s/\&amp;\([A-Za-z]*\);/\&\1;/" package/_MediaHelper.xslt

# Copy configs
cp calendarhelper/CalendarSettings.config package/
	
# Copy default templates
cp templates/Use*.xslt package/

# Transform the package.xml file, pulling in the README
xsltproc --novalid --xinclude --output package/package.xml lib/freezeEntities.xslt package.xml

# Build the ZIP file 
zip -j "dist/XSLTHelpers-$VERSION.zip" package/* -x \*.DS_Store

# Copy the release XSLT into the dist dir for upgraders
cp package/_PaginationHelper.xslt dist/xslt/helpers/
cp package/_NavigationHelper.xslt dist/xslt/helpers/
cp package/_GroupingHelper.xslt dist/xslt/helpers/
cp package/_CalendarHelper.xslt dist/xslt/helpers/
cp package/_MediaHelper.xslt dist/xslt/helpers/
cp package/_MultiPickerHelper.xslt dist/xslt/helpers/
cp package/*.config dist/config/

# Go back to DEVELOPMENT versions again
sed -i "" "s/$UMBON/$UMBOFF/" */entities.ent
sed -i "" "s/$TMOFF/$TMON/" */entities.ent

sed -i "" "s/$UMBON/$UMBOFF/" lib/mocks/entities.ent
sed -i "" "s/$TMOFF/$TMON/" lib/mocks/entities.ent
