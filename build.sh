# Create the dist directory if needed
if [[ ! -d dist ]]
	then mkdir dist
fi
# Likewise, create the package dir
if [[ ! -d package ]]
	then mkdir package
fi

# Make sure to use the PRODUCTION entities
sed -i 's/umbraco "IGNORE">/umbraco "INCLUDE"/' mediahelpers/entities.ent
sed -i 's/umbraco "IGNORE">/umbraco "INCLUDE"/' paginationhelper/entities.ent
sed -i 's/textmate "INCLUDE">/textmate "IGNORE"/' mediahelpers/entities.ent
sed -i 's/textmate "INCLUDE">/textmate "IGNORE"/' paginationhelper/entities.ent


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