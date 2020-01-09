
import { NativeModules } from 'react-native';
import AliBCWebView from './lib/AliBCWebView';

const { RNAliBC } = NativeModules;

export { AliBCWebView, RNAliBC };
export default RNAliBC;