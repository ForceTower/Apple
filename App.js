import React from 'react'
import {
    Text,
    View
} from 'react-native'

const styles = {
    container: {
        flex: 1
    },
    welcome: {
        justifyContent: 'center',
        alignItems: 'center'
    }
}

export default class App extends React.PureComponent {
    componentDidMount = () => {
        console.log('stuff just happened')
    }

    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>Welcome to UNES</Text>
            </View>
        )
    }
}
