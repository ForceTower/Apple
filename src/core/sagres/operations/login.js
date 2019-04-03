import SagresAPI from '../backend'

export default class Login {
    static perform = ({ username, password }) => {
        SagresAPI.login({ username, password }).then((response) => {
            console.log('It is complete! It\'s really close now')
            console.log(response)
        }).catch((error) => {
            console.log('Well... It\'s the first try...')
            console.log(error.response)
        })
    }
}
