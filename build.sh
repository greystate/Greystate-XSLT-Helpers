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
sed -i "" "s/$UMBOFF/$UMBON/" mediahelpers/entities.ent
sed -i "" "s/$UMBOFF/$UMBON/" paginationhelper/entities.ent
sed -i "" "s/$TMON/$TMOFF/" mediahelpers/entities.ent
sed -i "" "s/$TMON/$TMOFF/" paginationhelper/entities.ent

# Transform the development XSLT into the release file
xsltproc --novalid --output package/_PaginationHelper.xslt lib/freezeEntities.xslt paginationhelper/_PaginationHelper.xslt
xsltproc --novalid --output package/_MediaHelper.xslt lib/freezeEntities.xslt mediahelpers/_MediaHelper.xslt
cp mediahelpers/cropping-config.xml package/cropping-config.xml

# Transform the package.xml file, pulling in the README
# xsltproc --novalid --xinclude --output package/package.xml lib/freezeEntities.xslt src/package.xml

# Build the ZIP file 
zip -j dist/XSLTHelpers package/* -x \*.DS_Store

# Copy the release XSLT into the dist dir for upgraders
cp package/_PaginationHelper.xslt dist/_PaginationHelper.xslt
cp package/_MediaHelper.xslt dist/_MediaHelper.xslt
cp package/cropping-config.xml dist/cropping-config.xml

# Go back to DEVELOPMENT versions again
sed -i "" "s/$UMBON/$UMBOFF/" mediahelpers/entities.ent
sed -i "" "s/$UMBON/$UMBOFF/" paginationhelper/entities.ent
sed -i "" "s/$TMOFF/$TMON/" mediahelpers/entities.ent
sed -i "" "s/$TMOFF/$TMON/" paginationhelper/entities.ent
