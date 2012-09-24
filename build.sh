# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir dist
fi
# Likewise, create the package dir
if [[ ! -d package ]]
	then mkdir package
fi

# Make sure to use the PRODUCTION entities
UMBOFF="umbraco \"IGNORE\""
UMBON="umbraco \"INCLUDE\""

TMOFF="textmate \"IGNORE\""
TMON="textmate \"INCLUDE\""

sed -i "" "s/$UMBOFF/$UMBON/" */entities.ent
sed -i "" "s/$TMON/$TMOFF/" */entities.ent

# Transform the development XSLT into the release files
xsltproc --novalid --output package/_PaginationHelper.xslt lib/freezeEntities.xslt paginationhelper/_PaginationHelper.xslt
xsltproc --novalid --output package/_NavigationHelper.xslt lib/freezeEntities.xslt navigationhelper/_NavigationHelper.xslt
xsltproc --novalid --output package/_GroupingHelper.xslt lib/freezeEntities.xslt groupinghelper/_GroupingHelper.xslt
xsltproc --novalid --output package/_CalendarHelper.xslt lib/freezeEntities.xslt calendarhelper/_CalendarHelper.xslt
xsltproc --novalid --output package/_MediaHelper.xslt lib/freezeEntities.xslt mediahelpers/_MediaHelper.xslt

# Fix transformed entity references in attributes
sed -i "" "s/\&amp;\(.*\);/\&\1;/" package/_NavigationHelper.xslt
sed -i "" "s/\&amp;\(.*\);/\&\1;/" package/_CalendarHelper.xslt
sed -i "" "s/\&amp;\(.*\);/\&\1;/" package/_MediaHelper.xslt

# Copy configs
cp mediahelpers/cropping-config.xml package/cropping-config.xml
cp calendarhelper/calendar-config.xml package/calendar-config.xml

# Copy default templates
cp templates/Use*.xslt package/

# Transform the package.xml file, pulling in the README
xsltproc --novalid --xinclude --output package/package.xml lib/freezeEntities.xslt package.xml

# Build the ZIP file 
zip -j dist/XSLTHelpers package/* -x \*.DS_Store

# Copy the release XSLT into the dist dir for upgraders
cp package/_PaginationHelper.xslt dist/_PaginationHelper.xslt
cp package/_NavigationHelper.xslt dist/_NavigationHelper.xslt
cp package/_GroupingHelper.xslt dist/_GroupingHelper.xslt
cp package/_CalendarHelper.xslt dist/_CalendarHelper.xslt
cp package/_MediaHelper.xslt dist/_MediaHelper.xslt
cp package/cropping-config.xml dist/cropping-config.xml
cp package/calendar-config.xml dist/calendar-config.xml

# Go back to DEVELOPMENT versions again
sed -i "" "s/$UMBON/$UMBOFF/" */entities.ent
sed -i "" "s/$TMOFF/$TMON/" */entities.ent
