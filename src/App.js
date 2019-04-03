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

export default class App extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            name: null
        }
    }

    componentDidMount = () => {
        console.log('stuff just happened')
        SagresNavigator.login('username', 'password').then((name) => {
            this.setState({ name })
        }).catch(error => console.log(error))
    }

    render = () => {
        const { name } = this.state
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>{`Welcome to UNES ${name || ''}`}</Text>
            </View>
        )
    }
}
