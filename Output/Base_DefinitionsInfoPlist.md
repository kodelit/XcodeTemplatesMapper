# Base_DefinitionsInfoPlist

## TemplateInfo

### Identifier

- com.apple.dt.unit.base_DefinitionsInfoPlist ( [directory](/Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/Project%20Templates/Base/Base_DefinitionsInfoPlist.xctemplate), [plist](/Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/Project%20Templates/Base/Base_DefinitionsInfoPlist.xctemplate/TemplateInfo.plist) )

---
<span id="m_Definitions">[Definitions](#a_Definitions)</span>

### Definitions :  <span id="a_Definitions"/>[↩](#m_Definitions)

- `Info.plist` : 

	- Beginning : 

	```
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
	
	```

	- End : 

	```
	</dict>
	</plist>
	```

	- Indent : `YES`

	- SortOrder : `200`

	- SubstituteMacros : `YES`

	- TargetIdentifiers : 

- `Info.plist:BundleName` : 

```
<key>CFBundleName</key>
<string>$(PRODUCT_NAME)</string>

```

- `Info.plist:DevelopmentRegion` : 

```
<key>CFBundleDevelopmentRegion</key>
<string>$(DEVELOPMENT_LANGUAGE)</string>

```

- `Info.plist:Executable` : 

```
<key>CFBundleExecutable</key>
<string>$(EXECUTABLE_NAME)</string>

```

- `Info.plist:Identifier` : 

```
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>

```

- `Info.plist:PlistVersion` : 

```
<key>CFBundleInfoDictionaryVersion</key>
<string>6.0</string>

```

- `Info.plist:ProductVersion` : 

```
<key>CFBundleShortVersionString</key>
<string>1.0</string>
<key>CFBundleVersion</key>
<string>1</string>

```

### Kind : `Xcode.Xcode3.ProjectTemplateUnitKind`