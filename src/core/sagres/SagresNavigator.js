import {
    Login,
    Messages
} from './operations'

class SagresNavigator {
    login = (username, password) => Login.perform({ username, password })

    messages = () => Messages.perform()
}

export default new SagresNavigator()
