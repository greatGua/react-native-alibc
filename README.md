
# react-native-alibc

## Getting started

`$ npm install react-native-alibc --save`

### Mostly automatic installation

`$ react-native link react-native-alibc`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-alibc` and add `RNAlibc.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNAlibc.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.inshare.alibc.RNAlibcPackage;` to the imports at the top of the file
  - Add `new RNAlibcPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-alibc'
  	project(':react-native-alibc').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-alibc/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-alibc')
  	```


## Usage
```javascript
import RNAlibc from 'react-native-alibc';

// TODO: What to do with the module?
RNAlibc;
```
  