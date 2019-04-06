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

    componentDidMount = async () => {
        console.log('stuff just happened')
        try {
            const name = await SagresNavigator.login('username', 'password')
            this.setState({ name })
            await SagresNavigator.messages()
        } catch (error) {
            console.log(error)
        }
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
