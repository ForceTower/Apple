import { Navigation } from 'react-native-navigation'
import App from './src/App'
import { name as appName } from './app.json'

Navigation.registerComponent(appName, () => App)

Navigation.events().registerAppLaunchedListener(() => {
    Navigation.setRoot({
        root: {
            component: {
                name: appName
            }
        }
    })
})
