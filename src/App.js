import React from 'react'
import {
    Text,
    View
} from 'react-native'
import SagresNavigator from './core/sagres/SagresNavigator'

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
        SagresNavigator.login('cookies', 'are_a_problem')
    }

    render = () => {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>Welcome to UNES</Text>
            </View>
        )
    }
}
