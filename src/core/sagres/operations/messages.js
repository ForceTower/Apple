import SagresAPI from '../backend/index'

export default class Messages {
    static perform = () => {
        SagresAPI.messages().then((response) => {
            console.log('It is complete! It\'s basically done now')
            console.log(response)
        }).catch((error) => {
            console.log('The error has arived')
            console.log(error)
        })
    }
}
